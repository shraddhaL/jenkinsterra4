package com.testautomationguru.container.test;


import org.testng.Assert;
import org.testng.annotations.BeforeTest;
import org.testng.annotations.DataProvider;
import org.testng.annotations.Test;
import java.net.MalformedURLException;
import com.testautomationguru.container.pages.SearchPage;
import com.google.common.util.concurrent.Uninterruptibles;
import org.testng.annotations.BeforeSuite;
import org.testng.annotations.BeforeTest;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.concurrent.TimeUnit;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.remote.RemoteWebDriver;
import org.testng.annotations.AfterTest;
import org.openqa.selenium.PageLoadStrategy;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.ie.InternetExplorerDriver;
import org.openqa.selenium.remote.CapabilityType;
public class SearchTest {
protected WebDriver driver;
    
      @BeforeSuite
    public void initialDelay(){
        //intentionally added this as chrome/firefox containers take few ms to register
        //to hub - test fails saying hub does not have node!!
        //very rare
        Uninterruptibles.sleepUninterruptibly(2, TimeUnit.SECONDS);
        
    }
    @BeforeTest
    public void setUp()  {
        System.out.println("before test");  
    }

   @Test()
    public void googleTest() throws MalformedURLException {
        
        DesiredCapabilities capabilities = DesiredCapabilities.chrome();
        ChromeOptions options = new ChromeOptions();
        options.addArguments("headless");
        capabilities.setCapability(ChromeOptions.CAPABILITY,options);
        driver = new RemoteWebDriver(new URL("http://localhost:4444/wd/hub"), capabilities);
        driver.manage().window().maximize();
        
        
        driver.get("http://devopsteamgoa.westindia.cloudapp.azure.com:9090/MusicStore/index.html");  
        // get the current URL of the page   
        String URL= driver.getCurrentUrl();  
        System.out.println("current URL of the page fetched: "+URL); 
        //get the title of the page  
        String title = driver.getTitle();                  
        System.out.println("Title: "+title);  
        if(title.equals("MusicStore"))
             {Assert.assertTrue(true);
             System.out.println("1");  
             }
        else
            {Assert.assertTrue(false);
             System.out.println("0");  
            }
        
        
        
        
    }
    @AfterTest
    public void tearDown() throws InterruptedException {
        driver.close();
        driver.quit();
    }  

}
