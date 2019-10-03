# crystal-support-atom-extension

![A screenshot of your package](https://f.cloud.github.com/assets/69169/2290250/c35d867a-a017-11e3-86be-cd7c5bf3ff9b.gif)

#### Tested with amazing website BrowserStack.com - App & Browser Testing Made Easy
![BrowserStack.com](https://www.browserstack.com/images/layout/browserstack-logo-600x315.png)

### To run dev version

1. `npm install`
2. `cd libs/extractor && ./docker.sh`
3. `./build.sh`
4. `exit` - exit docker instance
5. `git clone https://github.com/crystal-lang/crystal.git --depth=1` - in libs/extractor
5. `guard` - in root dir (after start guard watch - press enter to compile all coffee files)
6. `apm link --dev && atom --dev`
