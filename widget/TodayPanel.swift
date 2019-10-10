import UIKit
import wtrackKit

class TodayPanel: UIView {
    @IBOutlet private var titleLabel: UILabel?
    @IBOutlet private var detailLabel: UILabel?
    @IBOutlet private var progressBarContainer: UIView?

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        let bundle = Bundle(for: type(of: self))
        let xib = UINib(nibName: "TodayPanel", bundle: bundle)
        guard let view = xib.instantiate(withOwner: self, options: nil).first as? UIView else { fatalError("faile to instantiate xib") }
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.fillInSuperview()

        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8

        progressBarContainer?.clipsToBounds = true
        progressBarContainer?.layer.cornerRadius = 2
    }

    func setTitleText(_ text: String) {
        titleLabel?.text = text
    }

    func setDetailText(_ text: String) {
        detailLabel?.text = text
    }

    func setProgress(progressValues: [Double], goal: Double) {
        progressBarContainer?.subviews.forEach { $0.removeFromSuperview() }

        let progressBar = MultiSegmentProgressBar(rawSegmentValues: progressValues, goalValue: goal)
        progressBarContainer?.addSubview(progressBar)
        progressBar.fillInSuperview()

        let currentTotal = progressValues.reduce(0, +)
        detailLabel?.text = "\(Int(currentTotal)) / \(Int(goal))"

        let fraction = currentTotal / goal
        if fraction > 1 {
            progressBar.markerFraction = CGFloat(1.0 / fraction)
        }
    }
}
