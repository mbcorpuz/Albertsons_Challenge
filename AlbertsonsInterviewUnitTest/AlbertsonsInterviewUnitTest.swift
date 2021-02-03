//
//  AlbertsonsInterviewUnitTest.swift
//  AlbertsonsInterviewUnitTest
//
//  Created by Mark Anthony Corpuz on 2/1/21.
//

import XCTest
@testable import AlbertsonsInterview

class AlbertsonsInterviewUnitTest: XCTestCase {
    var sut: URLSession!

    override func setUpWithError() throws {
        super.setUp()
        sut = URLSession(configuration: .default)
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }

    func testValidCallToAppStoreGetHTTPSStatusCode200() {
        let url = URL(string: "https://apps.apple.com/us/app/safeway-delivery-pick-up/id687460321")
        let promise = expectation(description: "Status code: 200")

        let dataTask = sut.dataTask(with: url!) { data, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()

        wait(for: [promise], timeout: 5)
    }

    func testValidCallToRecipeWebsiteGetHTTPSStatusCode200() {
        let url = URL(string: "http://www.recipepuppy.com/api/?q=mushroom")
        let promise = expectation(description: "Status code: 200")

        let dataTask = sut.dataTask(with: url!) { data, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()

        wait(for: [promise], timeout: 5)
    }

    func testCodableRecipe() {
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "mushroom", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)

        do {
            let recipe = try JSONDecoder().decode(Recipe.self, from: data!)
            XCTAssertEqual(recipe.results.count, 10)
        } catch {
            XCTFail("Data didn't decode to Recipe")
        }
    }
}
