# Grijjy Deployment Manager
The Grijjy Deployment Manager (DeployMan) is a tool to simplify the deployment of files and folders for Android, iOS, MacOS and Linux apps written in Delphi. It is especially useful if you need to deploy a lot of files, such as 3rd party SDKs.

## Usage

Allen Drennan has written some blog posts and created a CodeRage video about this tool:

* [Embed Facebook SDK for Android in your Delphi mobile app (Part 2)](https://blog.grijjy.com/2017/01/30/embed-facebook-sdk-for-android-in-your-delphi-mobile-app-part-2/) (blog post)
* [iOS and macOS App Extensions with Delphi](https://blog.grijjy.com/2018/11/15/ios-and-macos-app-extensions-with-delphi/) (blog post)
* [Bulk file deployment with the Grijjy DeployMan](https://youtu.be/LL-JvYcuAzI) (CodeRage video)

## Installation and Dependencies

If you don't need or want to build the tool yourself, then you can download the executable from the [Releases page on GitHub](https://github.com/grijjy/GrijjyDeployMan/releases).

To build the tool yourself:

```shell
> git clone --recursive https://github.com/grijjy/GrijjyDeployMan
```

Make sure to clone the repository recursively, since it depends on a couple of other open source libraries:

* The [Neslib](https://github.com/neslib/Neslib) repository is a small base library used in various repositories by [Erik van Bilsen](https://github.com/neslib).
* The [Neslib.Xml](https://github.com/neslib/Neslib.Xml) repository is used to load and save Delphi project (.dproj) files. For more information about this library, checkout the blog post [An XML DOM with just 8 bytes per node](https://blog.grijjy.com/2020/10/07/an-xml-dom-with-just-8-bytes-per-node/).
* The [Grijjy Foundation](https://github.com/grijjy/GrijjyFoundation) repository contains a lot of foundation classes and utilities. For the deployment manager, it is used primarily to load and save deployment settings to a JSON file.

If you don't clone this repository recursively, then you need to manually clone the dependent repositories and make sure to add them to your search path in Delphi.

## Contributing

Contributions are welcome! If you want to contribute, you can either create a pull request or become a member of the repository. To request push access, please send an email to erik-at-grijjy-dot-com or allen-at-grijjy-dot-com with the name of your GitHub account.

## License

The Grijjy Deployment Manager is licensed under the Simplified BSD License.

See License.txt for details.
