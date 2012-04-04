cukunity
========

cukunity is an automation/testing framework that simplifies BDD testing of
[Unity 3D](http://unity3d.com) games.

## Description

cukunity is a tool inspired by the principles of Behaviour Driven Development.
Cukunity is a portmanteau of "Cucumber" and "Unity", and as so it provides
helpers to play nicely with [Cucumber](http://cukes.info), although it can be used standalone for
automation purposes.

In short, cukunity provides:

* A platform-agnostic API to install, uninstall, and execute Unity3D games on real hardware (no simulators or emulators required).
* A platform-agnostic API for simulating touch and keyboard input on your Unity3D games.
* The `cukunity` executable to help you bootstrap your Unity3D Projects, and so on.
* Default step definitions and helpers for Cucumber.
* Default rake tasks with which you can run Cucumber easily from.

## Limitations

Currently, the following limitations apply:

* Only Android 2.x and iOS 5.x are supported (in the future, it would be nice to have more platforms like Desktop/Flash/WebPlayer).
* iOS testing is only possible on MacOSX (since Xcode only runs on MacOSX).
* Currently, iOS testing will only work if you check the "Development Build" setting on the Build Settings window of your Unity project.
* Android testing is currently only possible on MacOSX, although this may change in the future with the inclusion of Windows/Linux (don't take this as a promise).

Please, check out the `Progress and Roadmap` section below for additional information.

## Requirements

* Ruby 1.9.x (you probably want to install it via [RVM](http://beginrescueend.com)).
* To use cukunity with cucumber, you need to install cucumber (e.g. `gem install cucumber`)
* Mac OS X 10.6 and above (tested on Snow Leopard but should work on Lion too).
* To test on iOS devices, you need [XCode 4.2](https://developer.apple.com/xcode/) or above (including the iOS SDK) and [mobiledevice](http://github.com/imkira/mobiledevice).
* To test on Android devices, you need [Android SDK](http://developer.android.com/sdk/) including the platform-tools package.

## Installation

In order to install cukunity, first make sure you have Ruby 1.9.x installed, and then type the following:

```
gem install cukunity
```

If you prefer to live on the edge, get and install the latest code from the repository:

```
git clone git://github.com/imkira/cukunity.git
cd cukunity
rake install
```

## Usage

```
Usage: cukunity [options] <command>

Commands:
doctor              Check your system for the required platform tools.
bootstrap <path>    Bootstrap your Unity project.
features [<path>]   Run cucumber against path containing feature files.

Options:
    -v, --[no-]verbose               Enable/Disable verbose mode.
        --[no-]android               Enable/Disable for Android development.
        --[no-]ios                   Enable/Disable for Android development.
    -h, --help                       This help screen.
```

### Checking your system for problems

After you install cukunity, please make sure you run `cukunity doctor`
to check your system for problems.
This command will check if you have the necessary tools in order to use
cukunity for iOS/Android testing. You can also pass `--no-ios` or `--no-android`
if you don't plan on testing on such platform.

### Bootstraping your cukunity project

To bootstrap cukunity, make sure you type the following:

```
cukunity bootstrap <path/to/your/Unity/project's/root/directory>
```

This will generate the necessary files within `Assets/Plugins`.
After this, please make sure you drag and drop a prefab called `CukunityInstance.prefab`
on to the first scene of your Unity3D project. You don't need to worry about
what happens to the prefab you just dragged when loading other scenes, or to
place it in every scene of your project. That has already been taken care of!

Finally, just rebuild your Unity3D project for Android/iOS (for iOS, make sure
you check the "Development Build" setting on the Build Settings window of your
Unity project).

### Running your cukunity features with cucumber

As an utility command, you can run your cukunity features via cucumber with:

```
cukunity features <path/to/your/cucumber/features/directory>
```

This command will `require 'cukunity/cucumber'` automatically for you,
and launch cucumber with the specified features directory as test input.
You will need to specify either `--no-ios` or `--no-android` to disable
testing on the specified platform.

## Default Step Definitions

The following list of step definitions is already available via `cukunity features`
command (alternatively `require 'cukunity/cucumber'`), so you don't need to
make a copy to yourself. You may find it useful though to use it as reference or
to modify it to suit your needs.

* [Installing your Game](http://github.com/imkira/cukunity/blob/master/lib/cukunity/cucumber/step_definitions/install_steps.rb)
* [Launching your Game](http://github.com/imkira/cukunity/blob/master/lib/cukunity/cucumber/step_definitions/install_steps.rb)
* [Get Current Scene Information](http://github.com/imkira/cukunity/blob/master/lib/cukunity/cucumber/step_definitions/get_scene_command_steps.rb)
* [Keyboard Input Simulation](http://github.com/imkira/cukunity/blob/master/lib/cukunity/cucumber/step_definitions/keyboard_input_steps.rb)
* [Touch Input Simulation](http://github.com/imkira/cukunity/blob/master/lib/cukunity/cucumber/step_definitions/touch_input_steps.rb)
* [Visible Object Selectors](http://github.com/imkira/cukunity/blob/master/lib/cukunity/cucumber/step_definitions/select_visible_steps.rb)
* [Force Loading of Unity Level](http://github.com/imkira/cukunity/blob/master/lib/cukunity/cucumber/step_definitions/load_level_command_steps.rb)

### i18n Support

[i18n](http://github.com/imkira/cukunity/blob/master/lib/cukunity/cucumber/step_definitions/i18n) support is also available.
Currently [Japanese](http://github.com/imkira/cukunity/blob/master/lib/cukunity/cucumber/step_definitions/i18n/ja) language is supported.

## Sample Scenarios

The following is a sample of how you could use cukunity with Cucumber to
test a "Sokoban" game.

```
Feature: Cukunity's Default Step Definitions Sample
  In order to test Unity games using cukunity without having to reinvent the wheel
  As a programmer
  I want to be able to use cukunity's default step definitions

  Background:
    # Specify fixtures/sokoban.apk (Android) or fixtures/sokoban.app (iOS) as the target game. 
    Given I install the app "fixtures/sokoban"
    # launch it on device
    And I launch it
    # You probably don't need this, but this will cause an Application.LoadLevel of "demo_title" level.
    And I load the "demo_title" level

  Scenario: Application finished launching
    # Verbose: make sure it is running.
    Then it should be running
    # Verbose: make sure the "demo_title" level is running.
    And it should be playing "demo_title" level
    # Make sure "MainMenu" GameObject exists.
    And I should have a GameObject named "MainMenu"
    # Make sure "OptionsMenu" GameObject does not exist.
    And I should not have a GameObject named "OptionsMenu"

  Scenario: Clear game
    # Tap the visible GameObject called "Play"
    When I tap "Play"
    # Tap the visible GameObject called "Up"
    And I tap "Up"
    # <ommited for simplicity>
    # A GameObject called "GameClear" should be visible.
    Then I should see "GameClear"
    # A label showing it took us "40" steps should be visible.
    And I should read "40"

  Scenario: Set player name 
    # Tap the visible GameObject called "PlayerName"
    When I tap "PlayerName"
    # When the keyboard is displayed on screen, type "Super Player".
    And I type "Super Player"
    # Then, there should be a label showing the current player's name.
    Then I should read "Super Player"

  Scenario: Quit application by tap the "Quit" menu button
    # Tap a visible GameObject called "Quit"
    When I tap "Quit" and wait 3 seconds
    # The application should not be running anymore.
    Then it should not be running
```

The original Unity project that includes the code of the game and cukunity support
is available [here](http://github.com/imkira/cukunity/blob/master/Unity).
The sample feature files can be found [here](http://github.com/imkira/cukunity/blob/master/features).

## Demonstration

I am sorry for the very low quality video, but I hope it helps you at least understand what
cukunity is all about. The video below demonstrates features such as [keyboard input simulation](http://github.com/imkira/cukunity/blob/master/features/keyboard_input.feature) and
[touch input simulation](http://github.com/imkira/cukunity/blob/master/features/touch_input.feature)
(the full samples can be found [here](http://github.com/imkira/cukunity/tree/master/features)).

[Demo Video](http://youtu.be/3etDThp4fMo)

## Documentation

cukunity's source code is lacking a lot of documentation.
I promise I will soon improve this situation, but in the meantime you can check the autogenerated
documentation [here](http://rubydoc.info/gems/cukunity/frames).

## Progress and Roadmap

Currently only GameObject parent-children relationship, and a few Unity 3D built-in
classes like GameObject, Component, Behavior, Camera, GUIElement, GUIText, GUITexture,
Transform, etc. are supported. Therefore, one of the primary objectives for the
following versions is to give support for all built-in classes, to facilitate the
use of project-specific classes (if possible avoiding reflection), and well-known plugins
like EZGUI.

It is also necessary to extend the list of default step definitions to support
the development of real-life projects, ideally, without having to write a single
step definition by oneself.

## Contribute

* Found a bug?
* Want to contribute and add a new feature?

Please fork this project and send me a pull request!

## License

cukunity is licensed under the MIT license:

www.opensource.org/licenses/MIT

## Copyright

Copyright (c) 2012 Mario Freitas. See [LICENSE.txt](http://github.com/imkira/cukunity/blob/master/LICENSE.txt) for further details.
