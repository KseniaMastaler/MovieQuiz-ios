import UIKit

final class MovieQuizViewController: UIViewController {
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!

        // MARK: - Data
        private let questions: [QuizQuestion] = [
            QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
            QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
            QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
            QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
            QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
            QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
            QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
            QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
            QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
            QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)
        ]

        private var currentQuestionIndex = 0
        private var correctAnswers = 0

        // MARK: - Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            setupFonts()
            showNextQuestion()
        }

        private func setupFonts() {
            // Используем точные имена, как в файлах шрифтов
            let mediumFont = UIFont(name: "YS Display-Medium", size: 20) ?? .systemFont(ofSize: 20, weight: .medium)
            let boldFont = UIFont(name: "YS Display-Bold", size: 23) ?? .systemFont(ofSize: 23, weight: .bold)

            yesButton.titleLabel?.font = mediumFont
            noButton.titleLabel?.font = mediumFont
            questionTitleLabel.font = mediumFont
            counterLabel.font = mediumFont
            textLabel.font = boldFont
        }

        // MARK: - Actions
        @IBAction private func yesButtonClicked(_ sender: UIButton) {
            let current = questions[currentQuestionIndex]
            showAnswerResult(isCorrect: true == current.correctAnswer)
        }

        @IBAction private func noButtonClicked(_ sender: UIButton) {
            let current = questions[currentQuestionIndex]
            showAnswerResult(isCorrect: false == current.correctAnswer)
        }

        // MARK: - Frame Feedback + Scoring
        private func showAnswerResult(isCorrect: Bool) {
            // Отключаем кнопки, чтобы избежать двойного нажатия
            yesButton.isEnabled = false
            noButton.isEnabled = false

            if isCorrect {
                correctAnswers += 1
            }

            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = isCorrect
                ? UIColor(named: "YP Green")?.cgColor
                : UIColor(named: "YP Red")?.cgColor
            imageView.layer.cornerRadius = 20

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.showNextQuestionOrResults()
                // Включаем кнопки обратно
                self.yesButton.isEnabled = true
                self.noButton.isEnabled = true
            }
        }

        // MARK: - Navigation Logic
        private func showNextQuestionOrResults() {
            if currentQuestionIndex == questions.count - 1 {
                // Показываем результат
                let resultText = "Ваш результат: \(correctAnswers)/10"
                let resultViewModel = QuizResultsViewModel(
                    title: "Этот раунд окончен!",
                    text: resultText,
                    buttonText: "Сыграть ещё раз"
                )
                show(quiz: resultViewModel)
            } else {
                currentQuestionIndex += 1
                let nextQuestion = questions[currentQuestionIndex]
                let viewModel = convert(model: nextQuestion)
                show(quiz: viewModel)
            }
        }

        // MARK: - Show Question
        private func showNextQuestion() {
            let model = questions[currentQuestionIndex]
            let viewModel = convert(model: model)
            show(quiz: viewModel)
        }

        // MARK: - Helpers: Show Question
        private func convert(model: QuizQuestion) -> QuizStepViewModel {
            QuizStepViewModel(
                image: UIImage(named: model.image) ?? UIImage(),
                question: model.text,
                questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
            )
        }

        private func show(quiz step: QuizStepViewModel) {
            // Сброс рамки перед показом нового вопроса
            imageView.layer.borderWidth = 0
            imageView.layer.borderColor = UIColor.clear.cgColor

            imageView.image = step.image
            textLabel.text = step.question
            counterLabel.text = step.questionNumber
        }

        // MARK: - Helpers: Show Result Alert
        private func show(quiz result: QuizResultsViewModel) {
            let alert = UIAlertController(
                title: result.title,
                message: result.text,
                preferredStyle: .alert
            )

            let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                self.showNextQuestion()
            }

            alert.addAction(action)
            present(alert, animated: true)
        }
    }

    // MARK: - Models
    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }

    struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }

    struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
