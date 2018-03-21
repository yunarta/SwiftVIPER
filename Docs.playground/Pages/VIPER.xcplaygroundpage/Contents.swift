/*: Playground - noun: a place where people can play
 ## Introduction
 In software design architecture, VIPER is an emerging architecture concept that is redefining component responsibility to improves code clarity by conforming to [Single Responsibility Principle](https://en.wikipedia.org/wiki/Single_responsibility_principle) that should lead to increase testability coverage.
 
 The most known origin of VIPER architecture idea can be traced back to Mutual Mobile article [Architecting iOS Apps with VIPER](https://www.objc.io/issues/13-architecture/viper/), where they explain how they applies [The Clean Architecture](https://8thlight.com/blog/uncle-bob/2012/08/13/the-clean-architecture.html) in their iOS application that became the birth of VIPER architecture.
 
 As with the emergence of any new challenging idea, the communities started to adopt and improves the idea, and revising early design flaws, there are many variation of how VIPER should be implemented, as well as many had written a framework or tools related to VIPER.
 
 The VIPER Architecture implementation discussed in this book is closely based on [Book of VIPER](https://github.com/strongself/The-Book-of-VIPER) by Rambler&Co.
 
 
 ## VIPER
 The word VIPER is a backronym for View, Interactor, Presenter, Entity, and Routing. The reason for further component separation is that the most well-know MVC model are usually miss-interpreted by developer which lead into writing a Massive View Controller especially in iOS application.
 
 > The stereotype of bad MVC usage by iOS developer is Model covers resource locator (database or network), View component are UIKit component, such as UILabel and so, then the Controller is UIViewController derivation, that leads to 15K line of code in the view controllers.
 
 VIPER's distinct layers help to deal with this kind of challenge by providing single responsibility principle for the locations of application logic, user interface, and navigational code.
 
 While VIPER sounds great in the beginning, there are still pros and cons of adopting VIPER into development
 
 Pros:
 
 - Increase of testability for application view and presentation layer
 - Modules are independent from eaach other. It makes the separate development environment and increases the code reusability.
 - Main architecture approaches are defined. So it's much easier to add new developer into the team or move project to another team.
 
 Cons:
 
 - Highly increases of the number of class in the project, as well as the complexity of creating the new module.
 - Some principles don't work with UIKit out of the box.
 - Lack of recommendations, best practices and complex application examples.
 
 > The cons of VIPER are generally coming from different programming background.
 >
 > If you start your mobile development from Java (J2ME and Android), the large number of classes that need to be created will be natural for you.
 >
 > If you start your mobile development from Objective-C (iOS and Mac), as you had been led to and accustomed to implement everything in UIViewController thus working with large number of classes will not be natural compared to large number of lines of code.
 
 ## VIPER Components
 Even though this book focus more on explaining the implementation rather then explaining VIPER Architecture concept, however lets reiterate VIPER component in detail before we continue to the implementation.
 
 ### View
 First of all, the ```View``` in VIPER is definitely not UIKit component.
 
 ```View``` component in VIPER single responsible is to render the entities that it acquires or observe from ```Presenter```, and when the user interact with the ```View```, it will notify and updates the ```Presenter``` accordingly.
 
 ![View and Presenter relation](Images/view-presenter.png)
 
 View State in this diagram is the information that is would likely required by the ```View``` to render it to User Interface.
 
 The dependency of ```View``` and ```Presenter``` is a one sided dependency, this will allow the view state to be presented by different View.
 
 
 Points
 
 - ```View``` is the only component in VIPER that deals with UIKit view components (UILabel, UIButton and so on)
 - ```View``` is the only component in VIPER that is not depended by any other VIPER components
 - Publish and observe pattern would be the best option, rather than knowing when to updates from a callback
 
 Testability
 
 - It only has a one sided dependency, then the ```View``` can be tested easily with a mock ```Presenter```
 
 ### Router
 
 ```Router``` in VIPER is the component that decide which assembly need to be loaded when requested by ```Presenter```.
 
 > In a concrete explanation such as in a list and detail navigation, the ```Presenter``` will send the detail identifier to the ```Router``` to load the detail activity assembly.
 
 ![Presenter and Router relation](Images/presenter-router.png)
 
 Points
 
 - In VIPER, navigation is started by sending route data whilst the end point where the termination of the routing is only known by ```Router```, not the ```Presenter```
 - ```Router``` should only build and configure assembly
 
 Testability
 
 - By attaching a mock ```Router``` to ```Presenter```, we can test whether the action will emits the correct route data
 
 ### Presenter
 
 ```Presenter``` is the place where you write the use case of the application, but not the application code that handles the loading or updating the resources such as HTTP request or database related code. Those functionality is part of ```Interactor``` instead.
 
 ![Presenter and Interactor relation](Images/presenter-interactor.png)
 
 Rule of thumb is application logic codes that are closer to how the user interact from UI should be written in ```Presenter``` side, while application logic codes that are closer on data preparation should be written in ```Interactor``` side.
 
 One of the main difference between ```Presenter``` and ```Interactor``` is that only ```Presenter``` interact with ```Router```
 
 Points
 
 - ```Presenter``` lifecycle is bound to the UI lifecycle
 - ```Presenter``` provides observable view states for ```View``` to render
 - ```Presenter``` provides entry point for ```View``` to invoke actions
 
 Testability
 
 - Same like ```View```, as ```Presenter``` only have a one sided dependency, the ```Presenter``` can be tested with a mock ```Router``` and ```Interactor```
 
 ### Interactor and Entity
 
 ```Entity``` described in Book of VIPER and Architecting iOS Apps with VIPER as the model object. However one should think that ```Entity``` also covers low level sub system such as the resource locator, socket connection and so on.
 
 ```Interactor``` in VIPER is the only component that interact with ```Entity``` component, performing locator task such as acquiring and updating the data model from it.
 
 ![Interactor and Entity relation](Images/interactor-entity.png)
 
 ## Reiterate VIPER
 
 Before we are moving on to the implementation, let us iterate VIPER components one more time in a more concrete explanation closer to its implementation in iOS.
 
 ### View
 
 - Operation relates to UIKit components must be written as part of ```View``` components such as
 - Setting a text to a UILabel
 - Listening to UITextField / UITextView updates from its delegate
 - Formatting data to be presented as a text or images
 - When an action leads to a different view controller, the creation of such view will be done in ```Router``` instead of ```View```
 
 ### Interactor
 
 - This component translates the raw data it gets from ```Entity``` to a useful data to be presented by ```Presenter```
 - The application logic written in ```Interactor``` are process that takes **data** from ```Presenter``` as input and produces notification or data as the output
 - ```Interactor``` components lifecycle are bound to application
 
 ### Presenter
 
 - This component provides application logic that takes **user action** as its input and produces notification or data as the output
 - ```Presenter``` components lifecycle are bound to ```View``` lifecycle, which follow UIViewController lifecycle
 - When an action leads to a different view, the creation of such view will be done in ```Router``` instead of ```Presenter```
 
 ### Entity
 
 - ```Entity``` can be described a data model
 - A low level resource locator can be though as ```Entity``` as well.
 - This is to distinguish  logical code that related to how the app should work, and how the low level component should working
 
 
 ### Router
 
 - A ```Router``` works by taking a set of data and decide which ```View``` should be created and navigate into it
*/
