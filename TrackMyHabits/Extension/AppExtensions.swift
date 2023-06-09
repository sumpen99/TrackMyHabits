//
//  AppExtensions.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-17.
//

import SwiftUI

/*extension UINavigationController {
    
    override open func viewDidLoad() {
        
        super.viewDidLoad()
        
        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [UIColor(Color(hex:0x3E5151)).cgColor, UIColor(Color(hex:0xDECBA4)).cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        
        let standard = UINavigationBarAppearance()
        standard.backgroundImage = gradient.toImage()

        let compact = UINavigationBarAppearance()
        compact.backgroundImage = gradient.toImage()

        let scrollEdge = UINavigationBarAppearance()
        scrollEdge.backgroundImage = gradient.toImage()

        self.navigationBar.standardAppearance = standard
        self.navigationBar.compactAppearance = compact
        self.navigationBar.scrollEdgeAppearance = scrollEdge
        
    }
    
}

extension CALayer {

    func toImage() -> UIImage {
        UIGraphicsBeginImageContext(self.frame.size)
        self.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage!
    }
    
}*/

extension Float{
    func remapValue(min1:Float,max1:Float,min2:Float,max2:Float) -> CGFloat{
        return CGFloat((max2-min2) * (self-min1) / (max1-min1) + min2)
    }
}

extension Int?{
    func zeroString() -> String{
        guard let value = self else { return "" }
        return value < 10 ? "0\(value)" : "\(value)"
    }
}

extension Int{
    func zeroString() -> String{
        return self < 10 ? "0\(self)" : "\(self)"
    }
}

extension Calendar{
    static func monthFromInt(_ month: Int) -> String {
        let monthSymbols = Calendar.current.monthSymbols
        let max = monthSymbols.count
        let monthInt = month-1
        if monthInt < 0 || monthInt >= max { return ""}
        return monthSymbols[monthInt].capitalizingFirstLetter()
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    func adding(days: Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.day = days

        return NSCalendar.current.date(byAdding: dateComponents, to: self)
    }
    
    func yesterDay() -> Date? {
        let calendar = Calendar.current
        var dayComponent = DateComponents()
        dayComponent.day = -1
        return calendar.date(byAdding: dayComponent, to: self)
    }
    
    func plusThisMuchDays(_ add:Int) -> Date? {
        let calendar = Calendar.current
        var dayComponent = DateComponents()
        dayComponent.day = add
        return calendar.date(byAdding: dayComponent, to: self)
    }
    
    func monthName() -> String{
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("LLLL")
        return df.string(from: self)
    }
    
    func dayName() -> String{
        let df = DateFormatter()
        df.setLocalizedDateFormatFromTemplate("EEEE")
        return df.string(from: self)
    }
    
    func dayValue() -> Int?{
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    
    func year() -> Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: self)
        
    }
    
    func month() -> Int {
        let calendar = Calendar.current
        return calendar.component(.month, from: self)
        
    }
    
    func day() -> Int {
        let calendar = Calendar.current
        return calendar.component(.day, from: self)
        
    }
    
    func nextWeekDay(weekday:Int) -> Date?{
        let cal = Calendar.current
        var comps = DateComponents()
        comps.weekday = weekday
        if let weekday = cal.nextDate(after: self, matching: comps, matchingPolicy: .nextTimePreservingSmallerComponents) {
            return weekday
        }
        return nil
    }
    
    func numberOfDaysTo(_ to: Date) -> Int? {
        let cal = Calendar.current
        let fromDate = cal.startOfDay(for: self) // <1>
        let toDate = cal.startOfDay(for: to) // <2>
        let numberOfDays = cal.dateComponents([.day], from: fromDate, to: toDate) // <3>
        
        return numberOfDays.day
    }
    
    func isSameDayAs(_ otherDay:Date) -> Bool{
        let cal = Calendar.current
        let order = cal.compare(self, to: otherDay, toGranularity: .day)

        switch order {
            case .orderedAscending:
                fallthrough
            case .orderedDescending:
                return false
            default:
                return true
        }
    }
    
    func compareTo(_ otherDay:Date) -> ComparisonResult{
        let cal = Calendar.current
        return cal.compare(self, to: otherDay, toGranularity: .day)
    }
    
    func hourMinuteSeconds() -> (hour:Int,minutes:Int,seconds:Int){
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self)
        let minutes = calendar.component(.minute, from: self)
        let seconds = calendar.component(.second, from: self)
        return (hour:hour,minutes:minutes,seconds:seconds)
    }
    
    func dayDateMonth() -> String{
        let components = self.get(.day, .month, .year)
        let day = self.dayName()
        let month = self.monthName()
        if let c_date = components.day{
            return "\(day.uppercased()) \(c_date) \(month.uppercased())"
        }
        return "\(day.uppercased())  \(month.uppercased())"
    }
    
    func dateMonthYear() -> String{
        let components = self.get(.day, .month, .year)
        let month = self.monthName()
        let year = self.year()
        // TISDAG 2 MAJ 2023
        if let c_date = components.day{
            return "\(c_date) \(month.uppercased()) \(year)"
        }
        return " ? \(month.uppercased()) \(year)"
    }
    
    func dayDateMonthYear() -> (dateformatted:String,weekday:String){
        let components = self.get(.day, .month, .year)
        var day = self.dayName()
        var month = self.monthName()
        let year = self.year()
        day.capitalizeFirst()
        month.capitalizeFirst()
        if let c_date = components.day{
            return (dateformatted:"\(c_date) \(month) \(year)",weekday:day)
        }
        return (dateformatted:"? \(month) \(year)",weekday:day)
    }
    
    static func fromISO8601StringToDate(_ dateToProcess:String) -> Date?{
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        return formatter.date(from: dateToProcess)
    }
    
    func toISO8601String() -> String{
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]

        return formatter.string(from: self)
    }
    
}



extension UITabBar{
    static func changeAppearance(){
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = APP_TAB_BACKGROUND_UI_COLOR
        tabBarAppearance.shadowColor = .white
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        //UITabBar.appearance().isTranslucent = false
        //UITabBar.appearance().barTintColor = UIColor(named: "Secondary")
    }
}

extension UINavigationBar {
    static func changeAppearance(clear: Bool) {
        let appearance = UINavigationBarAppearance()
        
        if clear {
            appearance.configureWithTransparentBackground()
        } else {
            appearance.backgroundColor = UIColor(Color.black.opacity(0.9))
            
            //appearance.configureWithDefaultBackground()
        }
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
    }
    
    static func changeAppearance(){
        let appearance = UINavigationBarAppearance()
        //appearance.configureWithOpaqueBackground()
        
        appearance.backgroundColor = APP_BACKGROUND_UI_COLOR

        let attrsLarge: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .black)
        ]
        let attrsSmall: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.monospacedSystemFont(ofSize: 20, weight: .black)
        ]
        appearance.titleTextAttributes = attrsSmall
        appearance.largeTitleTextAttributes = attrsLarge
        appearance.shadowColor = .white
        //UINavigationBar.appearance().prefersLargeTitles = false
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        
        UINavigationBar.appearance().titleTextAttributes = attrsLarge
        UINavigationBar.appearance().largeTitleTextAttributes = attrsLarge
    }
}

/*extension Circle{
    
    func gradientSemi(){
        let center = CGPoint(x: circleView.bounds.size.width / 2, y: bounds.size.height / 2)
        let circleRadius = bounds.size.width / 2
        let circlePath = UIBezierPath(arcCenter: center, radius: circleRadius, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 2, clockwise: true)

        let semiCircleLayer = CAShapeLayer()
        semiCircleLayer.path = circlePath.cgPath
        semiCircleLayer.lineCap = .round
        semiCircleLayer.strokeColor = UIColor.white.cgColor
        semiCircleLayer.fillColor = UIColor.clear.cgColor
        semiCircleLayer.lineWidth = 6
        semiCircleLayer.strokeStart = 0
        semiCircleLayer.strokeEnd  = 1

        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor, UIColor.green.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)

        gradient.frame = circleView.bounds
        gradient.mask = semiCircleLayer

        circleView.layer.addSublayer(gradient)
    }
}*/

extension Text{
    func lightCaption() -> some View{
        self.font(.caption).fontWeight(.light).foregroundColor(.gray)
    }
}

extension View{
    
    func hLeading() -> some View{
        self.frame(maxWidth: .infinity,alignment: .leading)
    }
    
    func hTrailing() -> some View{
        self.frame(maxWidth: .infinity,alignment: .trailing)
    }
    
    func hCenter() -> some View{
        self.frame(maxWidth: .infinity,alignment: .center)
    }
    
    func formButtonDesign(width:CGFloat,backgroundColor:Color) -> some View{
        modifier(FormButtonModifier(width: width, backgroundColor: backgroundColor))
    }
    func sectionHeader() -> some View{
        modifier(SectionHeaderModifier())
    }
    func fillSection() -> some View{
        self.modifier(FillFormModifier())
    }
    func onResultAlert(action:@escaping (()-> Void)) -> Alert{
        return Alert(
                title: Text(ALERT_TITLE),
                message: Text(ALERT_MESSAGE),
                dismissButton: .cancel(Text("OK"), action: { action() } )
        )
    }
    func onPrivacyAlert(actionPrimary:@escaping (()-> Void),
                        actionSecondary:@escaping (()-> Void)) -> Alert{
        return Alert(
                title: Text(ALERT_PRIVACY_TITLE),
                message: Text(ALERT_PRIVACY_MESSAGE),
                primaryButton: .destructive(Text("OK"), action: { actionPrimary() }),
                secondaryButton: .cancel(Text("AVBRYT"), action: { actionSecondary() } )
        )
    }
    func onAlertWithOkAction(title:String,message:String,actionPrimary:@escaping (()-> Void)) -> Alert{
        return Alert(
                title: Text(title),
                message: Text(message),
                primaryButton: .destructive(Text("OK"), action: { actionPrimary() }),
                secondaryButton: .cancel(Text("AVBRYT"), action: { })
        )
    }
    func removePredictiveSuggestions() -> some View {
        self.keyboardType(.alphabet)
            .disableAutocorrection(true)
            .autocapitalization(.none)
    }
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
    
}

extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.dropLast())
            }
        }
        return self
    }
}



extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
    
    func capitalizingFirstLetter() -> String {
          return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirst() {
        if self.isEmpty { return }
        self = self.capitalizingFirstLetter()
    }
}

extension Int {
    static func getUniqueRandomNumbers(min: Int, max: Int, count: Int) -> [Int] {
        var set = Set<Int>()
        while set.count < count {
            set.insert(Int.random(in: min...max))
        }
        return Array(set)
    }

}

extension RangeExpression where Bound: FixedWidthInteger {
    func randomElements(_ n: Int) -> [Bound] {
        precondition(n > 0)
        switch self {
        case let range as Range<Bound>: return (0..<n).map { _ in .random(in: range) }
        case let range as ClosedRange<Bound>: return (0..<n).map { _ in .random(in: range) }
        default: return []
        }
    }
}

extension Range where Bound: FixedWidthInteger {
    var randomElement: Bound { .random(in: self) }
}

extension ClosedRange where Bound: FixedWidthInteger {
    var randomElement: Bound { .random(in: self) }
}

extension Array {
    mutating func modifyForEach(_ body: (_ index: Index, _ element: inout Element) -> ()) {
        for index in indices {
            modifyElement(atIndex: index) { body(index, &$0) }
        }
    }

    mutating func modifyElement(atIndex index: Index, _ modifyElement: (_ element: inout Element) -> ()) {
        var element = self[index]
        modifyElement(&element)
        self[index] = element
    }
}

extension UIApplication {
    var keyWindow: UIWindow? {
        connectedScenes
            .compactMap {
                $0 as? UIWindowScene
            }
            .flatMap {
                $0.windows
            }
            .first {
                $0.isKeyWindow
            }
    }
}

private struct SafeAreaInsetsKey:EnvironmentKey {
    
    static var defaultValue: EdgeInsets {
        UIApplication.shared.keyWindow?.safeAreaInsets.swiftUiInsets ?? EdgeInsets()
    }
}

extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

private extension UIEdgeInsets {
    var swiftUiInsets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}

extension UIColor{
    static let darkBackground = UIColor(red:36,green:36,blue:36)
    static let darkCardBackground = UIColor(red:46,green:46,blue:46)
    
    convenience init(red:Int,green:Int,blue:Int,a:CGFloat = 1.0) {
        self.init(red:CGFloat(red)/255.0,
                  green:CGFloat(green)/255.0,
                  blue:CGFloat(blue)/255.0,
                  alpha:CGFloat(a))
    }
}

extension Color {
    
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
    
    init(dRed red:Double,dGreen green:Double,dBlue blue:Double){
        self.init(red: red/255.0,green: green/255.0,blue: blue/255.0)
    }
    
    static var cardColor:Color { return Color(hex: 0x314058)}
    static var lightBackground:Color { return Color(hex:0xecfffd) }
    static var darkBackground:Color { return Color(dRed: 36, dGreen: 36, dBlue: 36) }
    static var darkCardBackground:Color { return Color(dRed: 46, dGreen: 46, dBlue: 46) }
}
