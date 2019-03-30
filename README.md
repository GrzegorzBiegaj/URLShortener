# URLShortener

Created by Grzegorz Biegaj (4 days demo project)

## Project description

URLShortener is just an iOS demo app presenting clean code and application architecture.
* The aim is to build a client application using a RESTful API.
* The Main feature of the app is to generate shortened URL (through API request).
* The second feature of the app is to display the list of shortened URLs, generated in the past (through API request).
* Selecting an URL in the list should open the default web browser.
* Design, should look like this mock: https://imgur.com/zqLILsC

How it works: Long URL address provided by the user is shortened in the backend to the short URL link.

REMARK:
There is no any backend yet, so all the backend responses are mocked locally in the app. 

## Architecture

### Storyboards
For that simple app storyboards are good solution. Storyboards are split to possible small scenes accordingly to the ViewControllers.

### Unit tests
Most of possible unit tests exists.

### Dependency injection
Because of usage unit tests it was necessary to introduce dependecy injection to separate components.

### Dependencies
No external dependecies

### Programming tools
Xcode 10.1, swift 4.1
