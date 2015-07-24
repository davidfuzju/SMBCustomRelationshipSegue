# SMBCustomRelationshipSegue

[![CI Status](http://img.shields.io/travis/David Fu/SMBCustomRelationshipSegue.svg?style=flat)](https://travis-ci.org/David Fu/SMBCustomRelationshipSegue)
[![Version][image-1]][1]
[![License][image-2]][2]
[![Platform][image-3]][3]

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

I've managed to make the custom container view controller set up relationship with its child view controllers looks as Apple’s UINavigtaionController or UITabbarController do in storyboard.

there are two examples in example folder:

+ sidemenu

	this example uses `RESideMenu` as a custom container view controller to show how to use `SMBCustomRelationshipSegue` make your storyboard continuous and meaningful

	> `RESideMenu` is a very beautiful custom container view controller and here is the [link][4]

+ container

	this example is inspired by objc.io’s [Custom Container View Controller Transitions][5] and the repo is [here][6]. In that repo, the project implement the custom container view controller without any interface file, and I update it with `SMBCustomRelationshipSegue`, now the relationship between container view controller and child view controllers can be seen in storyboard

`SMBCustomRelationshipSegue` now supports `one to one` relationship(like UINavigationController’s rootViewController relationship segue) and `one to many` relationship (like UITabbarController’s viewControllers relationship segue). all you need to do are just two steps:

1. subclass your view controller or UIViewController, overwrite the method:

		- (NSArray *)relationships

return the array of your property names which you want build a relationship, the lib will check it for you whether it is a `one to one` or `one to many`.

2. you need control drag your storyboard. link a `custom relation ship` segue between container view controller and child view controllers. and name the segue identifier .

	+ `one to one` relationship should name with format 

			relationship_{{propertyName}}"

	+ `one to many` relationship should name with format 

			relationship_{{propertyName}}_{{index}}

you should ensure the index is continuous and started with 0

then it’s OK! followings are screenshot building relationships:

![][image-4]
![][image-5]
![][image-6]
![][image-7]

## Requirements

iOS 7.0 and iOS 7.0 +

## Installation

SMBCustomRelationshipSegue is available through [CocoaPods][7]. To install
it, simply add the following line to your Podfile:

	pod "SMBCustomRelationshipSegue"

## Author

David Fu, david.fu.zju.dev@gmail.com

## License

SMBCustomRelationshipSegue is available under the MIT license. See the LICENSE file for more info.

[1]:	http://cocoapods.org/pods/SMBCustomRelationshipSegue
[2]:	http://cocoapods.org/pods/SMBCustomRelationshipSegue
[3]:	http://cocoapods.org/pods/SMBCustomRelationshipSegue
[4]:	https://github.com/romaonthego/RESideMenu
[5]:	http://www.objc.io/issues/12-animations/custom-container-view-controller-transitions/
[6]:	https://github.com/objcio/issue-12-custom-container-transitions
[7]:	http://cocoapods.org

[image-1]:	https://img.shields.io/cocoapods/v/SMBCustomRelationshipSegue.svg?style=flat
[image-2]:	https://img.shields.io/cocoapods/l/SMBCustomRelationshipSegue.svg?style=flat
[image-3]:	https://img.shields.io/cocoapods/p/SMBCustomRelationshipSegue.svg?style=flat
[image-4]:	https://raw.githubusercontent.com/SuperMarioBean/SMBCustomRelationshipSegue/master/1.png
[image-5]:	https://raw.githubusercontent.com/SuperMarioBean/SMBCustomRelationshipSegue/master/2.png
[image-6]:	https://raw.githubusercontent.com/SuperMarioBean/SMBCustomRelationshipSegue/master/3.png
[image-7]:	https://raw.githubusercontent.com/SuperMarioBean/SMBCustomRelationshipSegue/master/4.png