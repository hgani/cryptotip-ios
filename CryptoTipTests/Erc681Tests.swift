import XCTest
@testable import CryptoTip

class Erc681Tests: XCTestCase {
    var payload: Erc681?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testErc681Urls() {
        payload = Erc681(url: URL(string: "ethereum:0x1234DEADBEEF5678ABCD1234DEADBEEF5678ABCD"))
        XCTAssertTrue(payload?.recipient == "0x1234DEADBEEF5678ABCD1234DEADBEEF5678ABCD")
        XCTAssertTrue(payload?.chainId == 1)
        
        payload = Erc681(url: URL(string: "ethereum:pay-0x1234DEADBEEF5678ABCD1234DEADBEEF5678ABCD"))
        XCTAssertTrue(payload?.recipient == "0x1234DEADBEEF5678ABCD1234DEADBEEF5678ABCD")
        XCTAssertTrue(payload?.chainId == 1)

        payload = Erc681(url: URL(string: "ethereum:foo-0x1234DEADBEEF5678ABCD1234DEADBEEF5678ABCD"))
        XCTAssertTrue(payload?.recipient == "foo-0x1234DEADBEEF5678ABCD1234DEADBEEF5678ABCD")
        XCTAssertTrue(payload?.chainId == 1)

        payload = Erc681(url: URL(string: "ethereum:foo-doge-to-the-moon.eth@42"))
        XCTAssertTrue(payload?.recipient == "foo-doge-to-the-moon.eth")
        XCTAssertTrue(payload?.chainId == 42)
    }
}

