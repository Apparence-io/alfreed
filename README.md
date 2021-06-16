<p align="center">
<a href="https://github.com/felangel/bloc/actions"><img src="https://github.com/felangel/bloc/workflows/build/badge.svg" alt="build"></a>
<a href="https://codecov.io/gh/Apparence-io/alfreed"><img src="https://codecov.io/gh/Apparence-io/alfreed/branch/master/graph/badge.svg?token=WYSESJJY0P"/></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
</p>

# Alfreed
[Apparence.io](https://apparence.io) studio flutter management library.
This lib is used for our apps and is open for all. 

This force split business logic / view for your pages. 


## Install
Add alfreed in your pubspec and import it. 
```dart
import 'package:alfreed/alfreed.dart';
```

## Getting Started

### Create a page builder
```dart
class SecondPage extends AlfreedPage<MyPresenter, MyModel, ViewInterface> {
  SecondPage({Object? args}) : super(args: args);

  @override
  AlfreedPageBuilder<MyPresenter, MyModel, ViewInterface> get alfreedPageBuilder {
    return AlfreedPageBuilder<MyPresenter, MyModel, ViewInterface>(
      key: ValueKey("presenter"),
      builder: (ctx, presenter, model) {
        return Scaffold(
          appBar: AppBar(title: Text(model.title ?? "")),
          // ... you page widgets are here
        );
      },
      presenterBuilder: (context) => MyPresenter(),
      interfaceBuilder: (context) => ViewInterface(context),
    );
  }
}
```

Every build or defered to let our navigation beeing responsible for building them. (see routing section).

* **builder**: build your flutter page content (widgets...)
* **presenterBuilder**: build your presenter (business logic class)
* **interfaceBuilder**: build your view interface (business logic call this class to interact with our application without knowing flutter). Goal is to hide flutter from our business logic. (***Example: showSnackBar(String message) Without any context in parameters***)
* **key**(***optionnal***): used to get a reference to the presenter

> Note: we extends [AlfreedPage] to handle hot reload. Without hot reload we could remove this layer. 

### Create a presenter 
Create a presenter extending ```Presenter``` class. 
This is where you write your business logic. 
There is only and only one presenter instance available in the widget tree. 

>An instance of this will be available in the builder method seen in previous stage (Create a page builder). 

```dart
class MyPresenter extends Presenter<MyModel, ViewInterface> {
    // ... write you business logic methods here
}
```

### Create state class
Basically this will contain everything you want to show on your page. This model is a simple class where you can wrap models ```ValueNotifier``` or ```Stream```.

```dart
class ViewInterface extends AlfreedView {
  ViewInterface(BuildContext context) : super(context: context);

  /// ... all your attributes you want to use in your page

  void showMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
```

## Routing
You can push our page widget in your app router. 
<br/>Like this:

```dart
Route<dynamic> route(RouteSettings settings) {
  switch(settings.name) {
      case "/":
        return MaterialPageRoute(builder: FirstPage());
      default:  
        return MaterialPageRoute(builder: SecondPage());
  }
}
```

## Responsive state management
Our build method contain a special context named ```AlfredContext```. 
This class contains a ```Device``` attribute you can use to make your view for different size of devices. 
> We used twitter bootstrap sizes ref to create range of devices

Device type can be :
* phone (***0px - 576px]***)
* tablet (***[576px - 992px]***)
* large (***[992px - 1200px]***)
* xlarge (***more than 1920px large***)

Example of using: 
```dart
AlfreedPageBuilder<MyPresenter, MyModel, ViewInterface>(
  key: ValueKey("presenter"),
  builder: (ctx, presenter, model) {
    return Scaffold(
      floatingActionButton: ctx.device < Device.large()
          ? FloatingActionButton(
              backgroundColor: Colors.redAccent,
              onPressed: () =>
                  presenter.addTodoWithRefresh("Button Todo created"),
              child: Icon(Icons.plus_one),
            )
          : null,
    );
  },
  presenterBuilder: (context) => MyPresenter(),
  interfaceBuilder: (context) => ViewInterface(context),
);
```
Here our floating button will be available only for devices smaller than large (phone and tablets).

<hr/>

## Animations
To create animations on your page you can use ```AlfreedPageBuilder``` factories:
- ```AlfreedPageBuilder<MyPresenter, MyModel, ViewInterface>.animated(...)``` for single animation controller 
- ```AlfreedPageBuilder<MyPresenter, MyModel, ViewInterface>.animatedMulti(...)``` or multiple animations controller
Then you have access to builder methods for your animations.

Basically animations are accessed through a map where you name them. This can help finding each animations back when you need them.  

> Animation(s) controller(s) and their animations will be available in your presenter and AlfreedPageBuilder builder methods within context. 

#### example:
```dart
 AlfreedPageBuilder<MyPresenter, MyModel, ViewInterface>.animated(
  singleAnimControllerBuilder: (ticker) {
    var controller =
        AnimationController(vsync: ticker, duration: Duration(seconds: 1));
    var animation1 = CurvedAnimation(
        parent: controller, curve: Interval(0, .4, curve: Curves.easeIn));
    var animation2 = CurvedAnimation(
        parent: controller, curve: Interval(0, .6, curve: Curves.easeIn));
    return {
      '': AlfreedAnimation(controller, subAnimations: [animation1, animation2])
    };
  },
  animListener: (context, presenter, model) {
    if (model.animate) {
      context.animations!.values.first.controller.forward(); //SIMPLIFY
    }
  },
  builder: (ctx, presenter, model) => ...,
  presenterBuilder: (context) => MyPresenter(),
  interfaceBuilder: (context) => ViewInterface(context),
);
```

Access to animations within presenter and start the first one: 
```dart
animations!.values.first.controller.forward();
```

## Page arguments
You can pass arguments from routing directly to your presenter like this
```dart
Route<dynamic> route(RouteSettings settings) {
  switch (settings.name) {
    case '/second':
      return MaterialPageRoute(builder: SecondPage(args: settings.arguments));
    default:
      return MaterialPageRoute(builder: myPageBuilder.build);
  }
}
```
now you can access args directly inside your presenter using:
```dart
this.args 
```

<hr/>

## Test

### Get presenter ref
Use ```AlfreedUtils``` to get a reference of your presenter instance. 
```dart
var presenter = AlfreedUtils.getPresenterByKey<MyPresenter, MyModel>(
    tester, ValueKey("presenter"));
```

* The Key must be unique and added to the ```AlfreedPageBuilder``` seen on step (***Create a page builder***)
* The application must be started using a pumpWidget
* the page is correctly build

### Mock presenter
Prefer using a real presenter but in some case this helps. 

> ***Doc incoming***

## VsCode snippets 
Preferences > User snippets 
```json
"Alfreed template": {
		"prefix": "alf",
		"description": "create an Alfreed templated page",
		"body": [
			"import 'package:flutter/material.dart';",
			"import 'package:alfreed/alfreed.dart';",
			"",
			"class ${1:name}ViewModel {}",
			"",
			"class ${1:name}ViewInterface extends AlfreedView {",
			"  ${1:name}ViewInterface(BuildContext context) : super(context: context);",
			"}",
			"",
			"class ${1:name}Page extends AlfreedPage<${1:name}Presenter, ${1:name}ViewModel, ${1:name}ViewInterface>  {",
			"",
			"  ${1:name}Page({Object? args}) : super(args: args);",
			"",
			"  @override",
			"  AlfreedPageBuilder<${1:name}Presenter, ${1:name}ViewModel, ${1:name}ViewInterface> get alfreedPageBuilder {",
			"    return AlfreedPageBuilder<${1:name}Presenter, ${1:name}ViewModel, ${1:name}ViewInterface>(",
			"      key: ValueKey('presenter'),",
			"      presenterBuilder: (context) => ${1:name}Presenter(),",
			"      interfaceBuilder: (context) => ${1:name}ViewInterface(context),",
			"      builder: (context, presenter, model) => null, //TODO",
			"    );",
			"  }",
			"}",
			"",
			"class ${1:name}Presenter extends Presenter<${1:name}ViewModel, ${1:name}ViewInterface> {",
			"",
			"  ${1:name}Presenter() : super(state: ${1:name}ViewModel());",
			"}"
		]
	}
```