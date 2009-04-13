package com.ryanberdeen.oneshow;

import java.io.IOException;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;

import com.ryanberdeen.rjs.server.RjsClient;
import com.ryanberdeen.rjs.server.RjsHandlerAdapter;
import com.ryanberdeen.rjs.server.RjsServer;

public class LiveServer extends RjsHandlerAdapter {
	private static final String CLIENT_PATHS_KEY = "paths";
	private static final String SERVER_PATH = "server";

	private HashMap<String, HashSet<RjsClient>> listeners;
	private HashSet<RjsClient> globalListeners;

	public LiveServer() {
		listeners = new HashMap<String, HashSet<RjsClient>>();
		globalListeners = new HashSet<RjsClient>();
	}

	@Override
	public void clientConnected(RjsClient client) throws Exception {
		client.setAttribute(CLIENT_PATHS_KEY, new HashSet<String>());
	}

	@SuppressWarnings("unchecked")
	private static HashSet<String> getClientPaths(RjsClient client) {
		return (HashSet<String>) client.getAttribute(CLIENT_PATHS_KEY);
	}

	private void subscribe(String path, RjsClient client) {
		HashSet<RjsClient> pathListeners;
		synchronized (listeners) {
			pathListeners = listeners.get(path);
			if (pathListeners == null) {
				pathListeners = new HashSet<RjsClient>();
				listeners.put(path, pathListeners);
			}
		}
		pathListeners.add(client);
		HashSet<String> clientPaths = getClientPaths(client);
		clientPaths.add(path);
	}

	@Override
	public void clientDisconnected(RjsClient client) throws Exception {
		for (String path : getClientPaths(client)) {
			listeners.get(path).remove(client);
		}
	}

	@Override
	public void messageReceived(RjsClient client, String message) throws Exception {
		int spaceIndex = message.indexOf(' ');
		if (spaceIndex < 1) {
			throw new RuntimeException("Invalid message: " + message);
		}
		String path = message.substring(0, spaceIndex);
		if (path.equals(SERVER_PATH)) {
			String targetMessage = message.substring(spaceIndex + 1);
			serverMessageReceived(client, targetMessage);
		}
		else {
			HashSet<RjsClient> pathListeners = listeners.get(path);
			if (pathListeners != null) {
				sendMessage(pathListeners, message);
			}
		}
		sendMessage(globalListeners, message);
	}

	private static void sendMessage(Collection<RjsClient> clients, String message) {
		for (RjsClient client : clients) {
			client.send(message);
		}
	}

	private void serverMessageReceived(RjsClient client, String message) {
		String[] parts = message.split(" ");
		if ("subscribe".equals(parts[0])) {
			if ("*".equals(parts[1])) {
				globalListeners.add(client);
			}
			else {
				subscribe(parts[1], client);
			}
		}
	}

	public static void main(String[] args) throws IOException {
		RjsServer server = new RjsServer();
		server.setPort(1843);
		server.setHandler(new LiveServer());
		server.start();
	}
}
