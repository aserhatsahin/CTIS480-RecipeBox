import UIKit

@IBDesignable
final class CircularProgressView: UIView {

    // MARK: - Inspectable
    @IBInspectable var progress: CGFloat = 0.0 {
        didSet {
            // didSet içinde setProgress çağırma! (sonsuz recursion olur)
            let clamped = max(0, min(1, progress))
            progressLayer.strokeEnd = clamped
        }
    }

    @IBInspectable var lineWidth: CGFloat = 10 { didSet { updatePaths() } }
    @IBInspectable var trackColor: UIColor = .systemGray4 { didSet { trackLayer.strokeColor = trackColor.cgColor } }
    @IBInspectable var progressColor: UIColor = .systemGreen { didSet { progressLayer.strokeColor = progressColor.cgColor } }

    @IBInspectable var startAngleDegrees: CGFloat = -90 { didSet { updatePaths() } }
    @IBInspectable var sweepAngleDegrees: CGFloat = 360 { didSet { updatePaths() } }

    // MARK: - Layers
    private let trackLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .clear

        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = lineWidth
        trackLayer.lineCap = .round

        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = lineWidth
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = max(0, min(1, progress))

        layer.addSublayer(trackLayer)
        layer.addSublayer(progressLayer)

        updatePaths()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updatePaths()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        updatePaths()
        progressLayer.strokeEnd = max(0, min(1, progress))
    }

    private func updatePaths() {
        guard bounds.width > 0, bounds.height > 0 else { return }

        let radius = (min(bounds.width, bounds.height) - lineWidth) / 2
        let center = CGPoint(x: bounds.midX, y: bounds.midY)

        let start = degreesToRadians(startAngleDegrees)
        let end = start + degreesToRadians(sweepAngleDegrees)

        let path = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: start,
                                endAngle: end,
                                clockwise: true)

        trackLayer.frame = bounds
        progressLayer.frame = bounds

        trackLayer.path = path.cgPath
        progressLayer.path = path.cgPath

        trackLayer.lineWidth = lineWidth
        progressLayer.lineWidth = lineWidth
    }

    private func degreesToRadians(_ deg: CGFloat) -> CGFloat {
        deg * .pi / 180
    }

    // MARK: - Public
    func setProgress(_ value: CGFloat, animated: Bool, duration: CFTimeInterval = 0.3) {
        let clamped = max(0, min(1, value))

        if animated {
            let anim = CABasicAnimation(keyPath: "strokeEnd")
            anim.fromValue = progressLayer.presentation()?.strokeEnd ?? progressLayer.strokeEnd
            anim.toValue = clamped
            anim.duration = duration
            anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            progressLayer.add(anim, forKey: "strokeEnd")
        }

        // Layer'ı set et
        progressLayer.strokeEnd = clamped
        // Property'yi güncelle (didSet recursion yok artık)
        progress = clamped
    }
}
