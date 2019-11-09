import UIKit

public class RunStatisticsView: Panel {

    // MARK: - Private properties

    private let workoutRepository: WorkoutRepository

    // MARK: - UI properties

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Statistics"
        return label
    }()

    private lazy var statsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = .mediumSpacing
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        return stackView
    }()

    private lazy var totalDistanceView: StatView = {
        let statView = StatView()
        statView.translatesAutoresizingMaskIntoConstraints = false
        statView.titleText = "Total distance"
        return statView
    }()

    private lazy var longestRunView: StatView = {
        let statView = StatView()
        statView.translatesAutoresizingMaskIntoConstraints = false
        statView.titleText = "Longest run"
        return statView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        fatalError()
    }

    required init?(coder _: NSCoder) {
        fatalError()
    }

    public init(workoutRepository: WorkoutRepository) {
        self.workoutRepository = workoutRepository
        super.init(frame: .zero)
        setup()
    }

    private func setup() {
        setupViews()
        populateViews()
    }

    private func setupViews() {
        addSubview(titleLabel)
        addSubview(statsStack)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            statsStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            statsStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .mediumLargeSpacing),
            statsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            statsStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumLargeSpacing),
        ])

        statsStack.addArrangedSubview(totalDistanceView)
        statsStack.addArrangedSubview(longestRunView)
    }

    private func populateViews() {
        totalDistanceView.statText = "\(Int(workoutRepository.totalKilometers.rounded())) km"

        if let longestRun = workoutRepository.longestRun {
            longestRunView.statText = "\(longestRun.distanceInKilometers.rounded()) km"
        } else {
            longestRunView.statText = "n/a"
        }
    }
}

// MARK: - StatView

private class StatView: UIView {

    // MARK: - UI properties

    private lazy var titleLabel: Label = {
        let label = Label(style: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var statsLabel: Label = {
        let label = Label(style: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Internal properties

    var titleText: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }

    var statText: String? {
        get { statsLabel.text }
        set { statsLabel.text = newValue }
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    required init() {
        super.init(frame: .zero)
        setup()
    }

    private func setup() {
        addSubview(titleLabel)
        addSubview(statsLabel)

        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: statsLabel.trailingAnchor, constant: -.mediumSpacing),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),

            statsLabel.topAnchor.constraint(equalTo: topAnchor),
            statsLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            statsLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
