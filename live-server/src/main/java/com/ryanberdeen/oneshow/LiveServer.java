package com.ryanberdeen.oneshow;

import java.io.IOException;
import java.util.Collection;
import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArraySet;

import com.ryanberdeen.rjs.server.RjsClient;
import com.ryanberdeen.rjs.server.RjsHandlerAdapter;
import com.ryanberdeen.rjs.server.RjsServer;

public class LiveServer extends RjsHandlerAdapter {
	private static final String CLIENT_PATHS_KEY = "paths";
	private static final String SERVER_PATH = "server";
	private static final String GLOBAL_LISTENER_PATH = "*";

	private ConcurrentHashMap<String, CopyOnWriteArraySet<RjsClient>> subscribers;
	private CopyOnWriteArraySet<RjsClient> clients;

	public LiveServer() {
		subscribers = new ConcurrentHashMap<String, CopyOnWriteArraySet<RjsClient>>();
		clients = new CopyOnWriteArraySet<RjsClient>();
	}

	@Override
	public void clientConnected(RjsClient client) throws Exception {
		client.setAttribute(CLIENT_PATHS_KEY, new CopyOnWriteArraySet<String>());
		clients.add(client);
		forwardMessage(null, "server-listener client-connected " + client.getRemoteAddress());
	}

	@SuppressWarnings("unchecked")
	private static CopyOnWriteArraySet<String> getClientPaths(RjsClient client) {
		return (CopyOnWriteArraySet<String>) client.getAttribute(CLIENT_PATHS_KEY);
	}

	private void subscribe(String path, RjsClient client) {
		CopyOnWriteArraySet<RjsClient> pathListeners;
		synchronized (subscribers) {
			pathListeners = subscribers.get(path);
			if (pathListeners == null) {
				pathListeners = new CopyOnWriteArraySet<RjsClient>();
				subscribers.put(path, pathListeners);
			}
		}
		pathListeners.add(client);
		CopyOnWriteArraySet<String> clientPaths = getClientPaths(client);
		clientPaths.add(path);
	}

	@Override
	public void clientDisconnected(RjsClient client) throws Exception {
		for (String path : getClientPaths(client)) {
			subscribers.get(path).remove(client);
		}
		clients.remove(client);
		forwardMessage(null, "server-listener client-disconnected " + client.getRemoteAddress());
	}

	@Override
	public void messageReceived(RjsClient client, String message) throws Exception {
		forwardMessage(client, message);
	}

	private void forwardMessage(RjsClient from, String message) {
		int spaceIndex = message.indexOf(' ');
		if (spaceIndex < 1) {
			throw new RuntimeException("Invalid message: " + message);
		}

		HashSet<RjsClient> clients = new HashSet<RjsClient>();
		Set<RjsClient> globalSubscribers = subscribers.get(GLOBAL_LISTENER_PATH);
		if (globalSubscribers != null) {
			clients.addAll(globalSubscribers);
		}

		String path = message.substring(0, spaceIndex);
		if (path.equals(SERVER_PATH)) {
			String targetMessage = message.substring(spaceIndex + 1);
			serverMessageReceived(from, targetMessage);
		}
		else {
			Set<RjsClient> pathSubscribers = subscribers.get(path);
			if (pathSubscribers != null) {
				clients.addAll(pathSubscribers);
			}
		}

		sendMessage(clients, message);
	}

	private static void sendMessage(Collection<RjsClient> clients, String message) {
		for (RjsClient client : clients) {
			client.send(message);
		}
	}

	private void serverMessageReceived(RjsClient client, String message) {
		String[] parts = message.split(" ");
		if ("subscribe".equals(parts[0])) {
			for (int i = 1; i < parts.length; i++) {
				subscribe(parts[i], client);
			}
		}
		else if ("list-clients".equals(parts[0])) {
			StringBuilder result = new StringBuilder();
			for (RjsClient c : clients) {
				result.append(c.getRemoteAddress());
				if (c == client) {
					result.append(" *");
				}
				for (String path : getClientPaths(c)) {
					result.append('\n');
					result.append(" ");
					result.append(path);
				}
			}
			client.send(result.toString());
		}
	}

	public static void main(String[] args) throws IOException {
		RjsServer server = new RjsServer();
		server.setPort(1843);
		server.setHandler(new LiveServer());
		server.start();
	}
}
