# URLShortener

Created by Grzegorz Biegaj (4 days demo project)

## Project description

URLShortener is just an iOS demo app presenting clean code and application architecture:
* the aim is to build a client application using a RESTful API
* the Main feature of the app is to generate shortened URL (through API request)
* the second feature of the app is to display the list of shortened URLs, generated in the past (through API request)
* additional feature of the app is to remove already generated shortened URLs (through API request)
* selecting an URL in the list should open the default web browser
* design, should look like this mock: https://imgur.com/zqLILsC

#### REMARKS:
* there is no any backend yet, so all the backend responses are mocked locally in the app
* user can switch between using local mock and backend by selecting urlSession property in RequestProtocol extension

## Architecture

### Storyboards
For that simple app storyboards are good solution. Storyboards are split to possible small scenes accordingly to the ViewControllers.

### Unit tests
Most of possible unit tests are implemented.

### Dependency injection
Because of usage unit tests it was necessary to introduce dependency injection to separate components.

### Dependencies
No external dependencies.

### Programming tools
Xcode 10.2.1, swift 5.0
