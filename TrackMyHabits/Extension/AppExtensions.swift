//
//  AppExtensions.swift
//  TrackMyHabits
//
//  Created by fredrik sundström on 2023-04-17.
//

import SwiftUI

func handleThrowable(_ function: @autoclosure () throws -> Any?,
                     onFunctionResult : @escaping ((ThrowableResult) -> Void)){
    var throwableResult = ThrowableResult()
    do{
        let result = try function()
        throwableResult.finishedWithoutError = true
        throwableResult.value = result
    }
    catch {
        throwableResult.finishedWithoutError = false
        throwableResult.value = error.localizedDescription
    }
    onFunctionResult(throwableResult)
}

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

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
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
    
    static func dayDateMonth() -> String{
        let date = Date()
        let components = date.get(.day, .month, .year)
        let day = date.dayName()
        let month = date.monthName()
        if let c_date = components.day{
            return "\(day.uppercased()) \(c_date) \(month.uppercased())"
        }
        return "\(day.uppercased())  \(month.uppercased())"
    }
}



extension UITabBar{
    static func changeAppearance(){
        let tabBarAppearance = UITabBarAppearance()
        //tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = APP_BACKGROUND_UI_COLOR
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
            .font: UIFont.monospacedDigitSystemFont(ofSize: 30, weight: .black)
        ]
        let attrsSmall: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.monospacedSystemFont(ofSize: 15, weight: .black)
        ]
        appearance.titleTextAttributes = attrsSmall
        appearance.largeTitleTextAttributes = attrsLarge
        appearance.shadowColor = APP_BACKGROUND_UI_COLOR
        //UINavigationBar.appearance().prefersLargeTitles = false
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
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

extension View{
    func formButtonDesign(width:CGFloat,backgroundColor:Color) -> some View{
        modifier(FormButtonModifier(width: width, backgroundColor: backgroundColor))
    }
    func sectionHeader() -> some View{
        modifier(SectionHeaderModifier())
    }
    func fillSection() -> some View{
        self.modifier(FillFormModifier())
    }
    func appLinearGradient() -> some View{
        return LinearGradient(gradient: Gradient(colors: [Color(hex:0x3E5151),Color(hex:0xDECBA4)]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
    }
    
    func onResultAlert(action:@escaping (()-> Void)) -> Alert{
        return Alert(
                title: Text(ALERT_TITLE),
                message: Text(ALERT_MESSAGE),
                dismissButton: .cancel(Text("OK"), action: { action() } )
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
    
    static var darkBackground:Color { return Color(dRed: 36, dGreen: 36, dBlue: 36) }
    static var darkCardBackground:Color { return Color(dRed: 46, dGreen: 46, dBlue: 46) }
}
