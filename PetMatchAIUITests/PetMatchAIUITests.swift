import XCTest

final class PetMatchAIUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testAppLaunchesSuccessfully() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Verify the app launches with the onboarding screen
        XCTAssertTrue(app.navigationBars["Pet Match Quiz"].exists || 
                      app.navigationBars["PetMatchAI"].exists)
    }
    
    func testTabBarNavigation() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-completeQuiz"]
        
        // Complete quiz by setting UserDefaults
        UserDefaults.standard.set(true, forKey: "hasCompletedQuiz")
        
        app.launch()
        
        // Verify tab bar exists with expected tabs
        XCTAssertTrue(app.tabBars.buttons["Home"].exists)
        XCTAssertTrue(app.tabBars.buttons["Browse"].exists)
        XCTAssertTrue(app.tabBars.buttons["Favorites"].exists)
        XCTAssertTrue(app.tabBars.buttons["Profile"].exists)
    }
    
    func testBrowseScreenShowsPets() throws {
        let app = XCUIApplication()
        
        // Skip quiz
        UserDefaults.standard.set(true, forKey: "hasCompletedQuiz")
        
        app.launch()
        
        // Tap Browse tab
        app.tabBars.buttons["Browse"].tap()
        
        // Verify pet cards appear
        XCTAssertTrue(app.collectionViews.cells.count > 0)
    }
}