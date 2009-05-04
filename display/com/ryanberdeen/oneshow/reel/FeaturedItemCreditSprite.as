package com.ryanberdeen.oneshow.reel {
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.text.TextField;
  import flash.text.TextFormat;

  class FeaturedItemCreditSprite extends Sprite {
    private var titleText:TextField;
    private var creditText:TextField;
    private var linkText:TextField;

    public function FeaturedItemCreditSprite(featureItem:Object, displayWidth:Number = 500) {
      var textBackground:Shape = new Shape();
      addChild(textBackground);

      var textFormat:TextFormat = new TextFormat();
      textFormat.font = 'Helvetica';
      textFormat.size = 12;
      textFormat.color = 0x333333;
      textFormat.bold = true;

      var textWidth:Number = 0;

      var textY = 10;

      if (featureItem.title) {
        titleText = new TextField();
        titleText.defaultTextFormat = textFormat;
        titleText.text = featureItem.title;
        // TODO dimension
        titleText.width = titleText.textWidth + 5;
        titleText.height = titleText.textHeight + 5;
        // TODO dimension
        titleText.x = 10;
        titleText.y = textY;
        addChild(titleText);

        textWidth = Math.max(textWidth, titleText.textWidth);
        textY += titleText.height;
      }

      if (featureItem.credit) {
        creditText = new TextField();
        creditText.defaultTextFormat = textFormat;
        creditText.text = featureItem.credit;
        creditText.wordWrap = true;
        // TODO dimension
        creditText.width = displayWidth;
        creditText.height = creditText.textHeight + 5;
        // TODO dimension
        creditText.x = 10;
        creditText.y = textY;
        addChild(creditText);

        textWidth = Math.max(textWidth, creditText.textWidth);
        textY += creditText.height;
      }

      if (featureItem.url) {
        linkText = new TextField();
        linkText.defaultTextFormat = textFormat;
        linkText.text = featureItem.url;
        // TODO dimension
        linkText.width = linkText.textWidth + 5;
        linkText.height = linkText.textHeight + 5;
        // TODO dimension
        linkText.x = 10;
        linkText.y = textY;
        addChild(linkText);

        textWidth = Math.max(textWidth, linkText.textWidth);
        textY += linkText.height;
      }

      if (textWidth > 0) {
        textWidth += 20;

        textBackground.graphics.beginFill(0xFFFFFF);
        // TODO dimension
        textBackground.graphics.drawRect(0, 0, textWidth, height + 15);
        textBackground.graphics.endFill();
      }
    }
  }
}
