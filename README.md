# Substratum-Builder-Resources

A way to automatically build Substratum overlays without testing it on your phone!

The script may change with development, but the following will remain consistent:

* Clone this repo somewhere near your substratum repo
* Run `sh [subfolder]/build-overlays.sh [absolute path to your assets/overlays/ directory]`
* Logs will be printed, but error logs will be under [subfolder]/builds/log.txt
* If log.txt is not empty, an error has occurred

At its core, build-overlays.sh works the same way the Substratum app does to compile the overlays. 
It will create an AndroidManifest.xml (ours is much simpler because it doesn't need meta-data), 
reference your package's res folder for resources and compare it to a framework-res.apk to check for compile time errors.

As of now, this script cannot test for type errors (it only takes in the res folder if it exists)/
