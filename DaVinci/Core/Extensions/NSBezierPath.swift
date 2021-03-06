
#if os(macOS)
import Quartz

public extension NSBezierPath {
    /// Returns `CGPath` equivalent.
    public var cgPath: CGPath {
        get { return transformToCGPath() }
    }
    
    /// Transforms the bezier path to a `CGPath`
    ///
    /// - returns: A `CGPath` transformed from the bezier path instance.
    fileprivate func transformToCGPath() -> CGPath {
        let path = CGMutablePath()
        if elementCount < 1 { return path }
        
        let points = UnsafeMutablePointer<NSPoint>.allocate(capacity: 3)
        var didClosePath = true
        
        for index in 0..<elementCount {
            let pathType = element(at: index, associatedPoints: points)
            
            switch pathType {
            case .moveToBezierPathElement:
                path.move(to: points[0])
            case .lineToBezierPathElement:
                path.addLine(to: points[0])
                didClosePath = false
            case .curveToBezierPathElement:
                path.addCurve(to: points[2], control1: points[0], control2: points[1])
                didClosePath = false
            case .closePathBezierPathElement:
                path.closeSubpath()
                didClosePath = true
            }
        }
        
        if !didClosePath { path.closeSubpath() }
        points.deallocate()
        return path
    }
    
    /// Fills a path with a given color.
    ///
    /// - parameter color: The color to use for filling the path.
    public func fill(with color: NSColor) {
        let context = NSGraphicsContext.current?.cgContext
        context?.saveGState()
        color.setFill()
        self.fill()
        context?.restoreGState()
    }
}

#endif
