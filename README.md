# IGListKit-MacOS-Sample
Contains MacOS Sample for using IGListKit. 
The application performs search in GitHub Repository, in anonymous user mode. 

The application is written in Objective-C. It implements MVVM pattern.
It uses external libraries: 
- [RAC] (https://github.com/ReactiveCocoa/ReactiveObjC/blob/master/README.md)
- [AFNetworking] (https://github.com/AFNetworking/AFNetworking/blob/master/README.md)
- [IGListKit] (https://github.com/Instagram/IGListKit/blob/master/README.md)

## Installation

The app uses submodules.
``
git clone https://github.com/yakushevichsv/IGListKit-MacOS-Sample.git
cd bar
git submodule update --init --recursive
``

## Notes

Search on GitHub is performed in anonymous mode.

1)Authentification token is not used.

2)X-Rate-Limits are not supported yet.

3)Error Messages are not displayed(Just in console).

4)Just only first page of results is displayed. First 30 items( `per_page = 30 `)
