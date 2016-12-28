# IGListKit-MacOS-Sample
Contains MacOS Sample for using IGListKit. 
The application performs search in GitHub Repository, in anonymous user mode. 

The application is written in Objective-C. It implements MVVM pattern.
It uses external libraries: 
- [RAC] (https://github.com/ReactiveCocoa/ReactiveObjC/blob/master/README.md)
- [AFNetworking] (https://github.com/AFNetworking/AFNetworking/blob/master/README.md)
- [IGListKit] (https://github.com/Instagram/IGListKit/blob/master/README.md)

## Installation

The app is installed using submodules.

``
git clone git://github.com/foo/bar.git
cd bar
git submodule update --init --recursive
``

## Notes

Search on GitHub is performed in anonymous mode.
...Authentification token is not used.
...X-Rate-Limits are not supported yet.
...Error Messages are not displayed(Just in console).
