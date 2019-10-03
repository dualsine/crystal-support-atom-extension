# crystal-support-atom-extension
             
                
![BrowserStack.com](https://www.browserstack.com/images/layout/browserstack-logo-600x315.png)
#### Tested with amazing website BrowserStack.com - App & Browser Testing Made Easy
We can test our plugin on twenty machines with different screen resolutions in minutes with BrowserStack.com!
          
                
                 
### To run dev version

1. `npm install`
2. `cd libs/extractor && ./docker.sh`
3. `./build.sh`
4. `exit` - exit docker instance
5. `git clone https://github.com/crystal-lang/crystal.git --depth=1` - in libs/extractor
5. `guard` - in root dir (after start guard watch - press enter to compile all coffee files)
6. `apm link --dev && atom --dev`
