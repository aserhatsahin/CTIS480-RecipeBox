import UIKit
import AVFoundation
import AudioToolbox

final class CookingModeVC: UIViewController {

    // MARK: - Outlets (Storyboard)
    @IBOutlet weak var stepsTableView: UITableView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var restartTimerBtn: UIButton!
    @IBOutlet weak var startTimerBtn: UIButton!
    @IBOutlet weak var circularProgressView: CircularProgressView!

    // (Opsiyonel) senin custom back buttonun varsa bağla
    @IBOutlet weak var backBtn: UIButton?

    // (Opsiyonel) Finish Cooking butonu eklediysen bağla
    // TouchUpInside -> finishTapped
    @IBOutlet weak var finishBtn: UIButton?

    // MARK: - Data
    var selectedRecipe: Recipe?
    private var steps: [String] = []

    // MARK: - Timer
    private var timer: Timer?
    private var isRunning: Bool = false
    private var isDone: Bool = false

    private var totalSeconds: Int = 1
    private var remainingSeconds: Int = 1

    // MARK: - Sound (Custom önerilir)
    private var audioPlayer: AVAudioPlayer?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        stepsTableView.dataSource = self
        stepsTableView.delegate = self
        stepsTableView.rowHeight = UITableView.automaticDimension
        stepsTableView.estimatedRowHeight = 90

        steps = selectedRecipe?.steps ?? []

        let minutes = selectedRecipe?.durationMinutes ?? 0
        totalSeconds = max(minutes * 60, 1)
        remainingSeconds = totalSeconds

        setupButtonsUI()
        renderUI()
    }

    deinit {
        stopTimer()
    }

    // MARK: - UI
    private func setupButtonsUI() {
        // Start button görünür olsun diye
        startTimerBtn.tintColor = .white
        var config = startTimerBtn.configuration ?? .filled()
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 26, weight: .bold)
        config.imagePadding = 0
        startTimerBtn.configuration = config

        restartTimerBtn.tintColor = .label

        updateStartButtonIcon()
    }

    private func renderUI() {
        timeLbl.text = formatTime(remainingSeconds)

        let progress = 1.0 - (Double(remainingSeconds) / Double(totalSeconds)) // 0..1
        circularProgressView.setProgress(CGFloat(progress), animated: true, duration: 0.2)

        updateStartButtonIcon()
        stepsTableView.reloadData()
    }

    private func updateStartButtonIcon() {
        var config = startTimerBtn.configuration ?? .filled()

        if isDone {
            config.image = UIImage(systemName: "checkmark")
            config.baseBackgroundColor = .systemGreen
            config.baseForegroundColor = .white
            startTimerBtn.isEnabled = false
        } else {
            let name = isRunning ? "pause.fill" : "play.fill"
            config.image = UIImage(systemName: name)
            config.baseBackgroundColor = .systemBlue
            config.baseForegroundColor = .white
            startTimerBtn.isEnabled = true
        }

        config.cornerStyle = .capsule
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 26, weight: .bold)
        startTimerBtn.configuration = config

        // ekstra garanti
        startTimerBtn.backgroundColor = isDone ? .systemGreen : .systemBlue
        startTimerBtn.tintColor = .white
    }

    // MARK: - Timer
    private func startTimer() {
        stopTimer()
        timer = Timer(timeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.tick()
        }
        RunLoop.main.add(timer!, forMode: .common)
    }

    private func tick() {
        guard !isDone else { return }

        if remainingSeconds > 0 {
            remainingSeconds -= 1
            timeLbl.text = formatTime(remainingSeconds)

            let progress = 1.0 - (Double(remainingSeconds) / Double(totalSeconds))
            circularProgressView.setProgress(CGFloat(progress), animated: true, duration: 0.15)
        }

        if remainingSeconds == 0 {
            finishCooking()
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func finishCooking() {
        stopTimer()
        isRunning = false
        isDone = true

        // Done olunca ring FULL olsun (finish butonuna erken bassan bile)
        remainingSeconds = 0

        // UI güncelle: ring 1.0 + checkmark
        renderUI()

        // Ses
        playFinishSound()
    }

    // MARK: - Sound Ayarı
    /// 1) Öncelik: custom ses dosyası (en güzel ve kontrol sende)
    /// 2) Yoksa: sistem click sesi fallback
    private func playFinishSound() {
        if let url = Bundle.main.url(forResource: "done", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
                return
            } catch {
                print("AudioPlayer error:", error)
            }
        }

        // fallback
        AudioServicesPlaySystemSound(1104)
    }
    private func formatTime(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }

    // MARK: - Actions
    @IBAction func startTimerTapped(_ sender: UIButton) {
        guard !isDone else { return }

        isRunning.toggle()
        if isRunning {
            startTimer()
        } else {
            stopTimer()
        }
        updateStartButtonIcon()
    }

    @IBAction func restartTapped(_ sender: UIButton) {
        stopTimer()
        isRunning = false
        isDone = false

        remainingSeconds = totalSeconds
        renderUI()
    }

    // ✅ Finish Cooking (test veya manuel bitirme)
    @IBAction func finishTapped(_ sender: UIButton) {
        guard !isDone else { return }
        finishCooking()
    }

    // Custom back button bağladıysan bunu kullan
    @IBAction func backTapped(_ sender: UIButton) {
        stopTimer()

        if navigationController != nil {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}

// MARK: - TableView
extension CookingModeVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return steps.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "CookingStepCell",
            for: indexPath
        ) as? CookingStepTableViewCell else {
            return UITableViewCell()
        }

        // Sabit görünüm: hepsi aynı
        cell.configure(
            stepText: steps[indexPath.row],
            stepNumber: indexPath.row + 1,
            isCurrent: false,
            isCompleted: false
        )

        return cell
    }
}
