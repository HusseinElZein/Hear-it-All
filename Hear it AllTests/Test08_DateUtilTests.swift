import XCTest
@testable import Hear_it_All

class DateUtilTests: XCTestCase {

    func testGetDateNow() {
        let dateNowString = DateUtil.getDateNow()
        XCTAssertFalse(dateNowString.isEmpty, "Date now should not be empty")
        XCTAssertNotNil(Int64(dateNowString), "Date now should be convertible to Int64")
    }

    func testGetTimeAgo() {
        let nowMilliseconds = Int64(Date().timeIntervalSince1970 * 1000)
        
        // Test for different time units: years, months, days, hours, minutes, and just now
        let oneYearMilliseconds = nowMilliseconds - 31_836_300_000 // 1 year in milliseconds
        let oneMonthMilliseconds = nowMilliseconds - 2_792_000_000 // 1 month in milliseconds
        let oneDayMilliseconds = nowMilliseconds - 86_400_000 // 1 day in milliseconds
        let oneHourMilliseconds = nowMilliseconds - 3_600_000 // 1 hour in milliseconds
        let oneMinuteMilliseconds = nowMilliseconds - 60_000 // 1 minute in milliseconds
        
        XCTAssertEqual(DateUtil.getTimeAgo(from: String(oneYearMilliseconds)), "1 \(Localized.DateLocalized.years_ago)")
        XCTAssertEqual(DateUtil.getTimeAgo(from: String(oneMonthMilliseconds)), "1 \(Localized.DateLocalized.month) \(Localized.DateLocalized.ago)")
        XCTAssertEqual(DateUtil.getTimeAgo(from: String(oneDayMilliseconds)), "1\(Localized.DateLocalized.d_ago)")
        XCTAssertEqual(DateUtil.getTimeAgo(from: String(oneHourMilliseconds)), "1\(Localized.DateLocalized.t_ago)")
        XCTAssertEqual(DateUtil.getTimeAgo(from: String(oneMinuteMilliseconds)), "1\(Localized.DateLocalized.m_ago)")
        XCTAssertEqual(DateUtil.getTimeAgo(from: String(nowMilliseconds)), Localized.DateLocalized.just_now)
        
        // Test invalid date
        XCTAssertEqual(DateUtil.getTimeAgo(from: "invalid"), "Invalid date")
    }
}
