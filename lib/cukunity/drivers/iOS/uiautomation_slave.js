UIAutomationSlave = function(address, port) {
  this.address = address;
  this.port = port; 

  this.target = UIATarget.localTarget();
  this.target.setTimeout(0);
  this.app = this.target.frontMostApp();
  this.host = this.target.host();

  this.result = {};
  this.running = true;
};

UIAutomationSlave.prototype.exchange = function(timeout) {
  var ruby, args = [], request;

  // prepare arguments to inform master of the result
  ruby = "{{ruby}}";
  args.push("{{slave}}");

  args.push(this.address);
  args.push(this.port.toString());
  args.push(JSON.stringify(this.result));

  timeout = timeout || 10;

  // inform master of result and get a new request
  try {
    request = this.host.performTaskWithPathArgumentsTimeout(ruby, args, timeout);
  }
  catch (e) {
    // timeout
    return this.running;
  };

  switch (request.exitCode) {
    case 0:
      try {
        this.result = this.execute(JSON.parse(request.stdout));
      }
      catch (e) {
        this.result = { "error" : e.message };
      }
      break;

    // connection refused
    case 2:
      break;

    case 1:
    default:
      UIALogger.logError("Could not connect to master: " + request.exitCode);
      this.result = {};
      break;
  }
  return this.running;
};

UIAutomationSlave.prototype.keyboard = function() {
  var keyboard = this.app.keyboard();
  if ((keyboard) && (keyboard.isValid()) && (keyboard.isVisible())) {
    return keyboard;
  }
  return null;
};

UIAutomationSlave.prototype.handleKeyboard = function(result, success, error) {
  var keyboard = this.keyboard();
  if (keyboard) {
    return success(keyboard);
  }
  result["error"] = "Keyboard currently unavailable";
  if (error) {
    return error();
  }
};

UIAutomationSlave.prototype.keyboardToolbar = function() {
  var keyboardToolbar;
  if (this.keyboard()) {
    keyboardToolbar = this.app.mainWindow().toolbar();
    if ((keyboardToolbar) && (keyboardToolbar.isValid()) &&
        (keyboardToolbar.isVisible())) {
      return keyboardToolbar;
    }
  }
  return null;
};

UIAutomationSlave.prototype.handleKeyboardToolbar = function(result, success, error) {
  var keyboardToolbar = this.keyboardToolbar();
  if (keyboardToolbar) {
    return success(keyboardToolbar);
  }
  result["error"] = "Toolbar currently unavailable";
  if (error) {
    return error();
  }
};

UIAutomationSlave.prototype.execute = function(request) {
  var command = request['command'], result = { 'command': command };

  // delete command from hash, so we can use the hash for passing into functions
  delete request['command'];

  // execute respective command
  switch (command) {
    case 'isKeyboardAvailable':
      if (this.keyboard()) {
        result["available"] = true;
      }
      else {
        result["available"] = false;
      }
      break;

    case 'typedText':
      this.handleKeyboardToolbar(result, function(keyboardToolbar) {
        var textField = keyboardToolbar.textFields().toArray()[0];
        if ((textField) && (textField.isValid())) {
          result["text"] = textField.value();
        }
        else {
          result["error"] = "Text field not currently unavailable";
        }
      });
      break;

    case 'clearText':
      this.handleKeyboardToolbar(result, function(keyboardToolbar) {
        var textField = keyboardToolbar.textFields().toArray()[0];
        if ((textField) && (textField.isValid())) {
          textField.setValue('');
        }
        else {
          result["error"] = "Text field not currently unavailable";
        }
      });
      break;

    case 'typeText':
      this.handleKeyboard(result, function(keyboard) {
        keyboard.typeString(request["text"]);
      });
      break;

    case 'keyboardButtons':
      this.handleKeyboard(result, function(keyboard) {
        var buttons = [], button, _buttons = keyboard.buttons().toArray();
        for (button in _buttons) {
          buttons[button] = _buttons[button].name();
        }
        result["keyboardButtons"] = buttons;
      });
      break;

    case 'tapKeyboardButton':
      this.handleKeyboard(result, function(keyboard) {
        var button = keyboard.buttons()[request["button"].toString()];
        if ((button) && (button.isValid())) {
          button.tap();
        }
        else {
          result["error"] = "Button currently unavailable";
        }
      });
      break;

    case 'keyboardKeys':
      this.handleKeyboard(result, function(keyboard) {
        var key, keys = [], _keys = keyboard.keys().toArray();
        for (key in _keys) {
          keys[key] = _keys[key].name();
        }
        result["keyboardKeys"] = keys;
      });
      break;

    case 'tapKeyboardKey':
      this.handleKeyboard(result, function(keyboard) {
        var key = keyboard.keys()[request["key"].toString()];
        if ((key) && (key.isValid())) {
          key.tap();
        }
        else {
          result["error"] = "Key currently unavailable";
        }
      });
      break;

    case 'keyboardToolbarButtons':
      this.handleKeyboardToolbar(result, function(keyboardToolbar) {
        var buttons = [], button, _buttons = keyboardToolbar.buttons().toArray();
        for (button in _buttons) {
          buttons[button] = _buttons[button].name();
        }
        result["keyboardToolbarButtons"] = buttons;
      });
      break;

    case 'tapKeyboardToolbarButton':
      this.handleKeyboardToolbar(result, function(keyboardToolbar) {
        var button = keyboardToolbar.buttons()[request["button"].toString()];
        if ((button) && (button.isValid())) {
          button.tap();
        }
        else {
          result["error"] = "Button currently unavailable";
        }
      });
      break;

    case 'bundleIdentifier':
      result['bundleIdentifier'] = "{{bundle_id}}";
      break;

    case 'terminate':
      this.running = false;
      break;

    default:
      result["error"] = "Unknown command";
      break;
  };

  return result;
};

(function() {
  // create automation slave
  var slave = new UIAutomationSlave("{{address}}", {{port}});

  // execute happily
  while (slave.exchange()) {
    // don't need to wait, it's already slow enough...
  }
})();
