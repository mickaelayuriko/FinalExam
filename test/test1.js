const { By, Builder, until } = require("selenium-webdriver");
const chrome = require("selenium-webdriver/chrome");

async function test_case() {

    //Set Chrome option
    let options = new chrome.Options();
    options.addArguments('headless');
    options.addArguments('disable-gpu')
    options.setChromeBinaryPath('/usr/bin/google-chrome');

    // Create a Driver
    let driver = await new Builder().forBrowser("chrome").setChromeOptions(options).build();

    try {
        // Step 1: Enter the website
        await driver.get("http://18.234.83.194/");

        // Step 2: Wait for the element with ID 'optionsDlg' to appear (Max 10 seconds)
        await driver.wait(until.elementLocated(By.id('optionsDlg')), 10000);

        // Step 3: Find and click the 'easy' radio input
        await driver.findElement(By.css("label > input[type='radio'][name='difficulty'][id='r0']")).click();

        // Step 4: Find and click the 'x (go first)' radio input
        await driver.findElement(By.css("label > input[type='radio'][name='player'][id='rx']")).click();

        // Step 5: Find and click the 'Play' button
        await driver.findElement(By.id('okBtn')).click();

        // Step 6: Find and click the element with ID 'cell0'
        let cell0 = await driver.findElement(By.id('cell0'));
        await cell0.click();

        // Step 7: Get the value of innerHTML text of the element found in step 6
        let cell0InnerHtml = await cell0.getAttribute('innerHTML');

        // Analyze the result:
        // Check if the value obtained is different than 'x'
        if (cell0InnerHtml !== 'x') {
            throw new Error(`Test failed: Expected 'x' but got '${cell0InnerHtml}'`);
        } else {
            console.log('Test passed!');
        }

    } catch (error) {
        console.log('An error accurred:', error);
    } finally {
        await driver.quit();
    }

}
test_case();