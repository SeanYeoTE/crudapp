import UIKit

protocol PlaceFormViewControllerDelegate: AnyObject {
    func didAddPlace(_ place: Place)
    func didUpdatePlace(_ place: Place)
}

extension PlaceFormViewControllerDelegate {
    func didAddPlace(_ place: Place) {}
    func didUpdatePlace(_ place: Place) {}
}

class PlaceFormViewController: UITableViewController {

    weak var delegate: PlaceFormViewControllerDelegate?
    var place: Place?

    private enum Section: Int, CaseIterable {
        case name, category, details, lastVisited, notes

        var title: String {
            switch self {
            case .name:        return "Name"
            case .category:    return "Category"
            case .details:     return "Details"
            case .lastVisited: return "Last Visited"
            case .notes:       return "Notes"
            }
        }
    }

    // MARK: - Input views

    private let nameField = UITextField()
    private let notesField = UITextField()
    private let categoryPicker = UIPickerView()
    private let ratingStepper = UIStepper()
    private let priceStepper = UIStepper()
    private let datePicker = UIDatePicker()

    // MARK: - Static cells

    private let nameCell = UITableViewCell()
    private let categoryCell = UITableViewCell()
    private let ratingCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
    private let priceCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
    private let dateCell = UITableViewCell()
    private let notesCell = UITableViewCell()

    init(place: Place? = nil) {
        self.place = place
        super.init(style: .insetGrouped)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = place == nil ? "New Place" : "Edit Place"

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            systemItem: .cancel,
            primaryAction: UIAction { [weak self] _ in
                self?.dismiss(animated: true)
            }
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            systemItem: .save,
            primaryAction: UIAction { [weak self] _ in
                self?.saveTapped()
            }
        )

        setUpInputs()
        configureForEditing()
    }

    // MARK: - Setup

    private func setUpInputs() {
        nameField.placeholder = "e.g. Tiong Bahru Bakery"
        nameField.autocapitalizationType = .words
        nameField.clearButtonMode = .whileEditing
        embed(nameField, in: nameCell)

        notesField.placeholder = "Optional"
        embed(notesField, in: notesCell)

        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        embed(categoryPicker, in: categoryCell)

        ratingStepper.minimumValue = 0
        ratingStepper.maximumValue = 5
        ratingStepper.stepValue = 0.5
        ratingStepper.value = 3
        ratingStepper.addAction(UIAction { [weak self] _ in self?.updateStepperLabels() },
                                for: .valueChanged)
        ratingCell.textLabel?.text = "Rating"
        ratingCell.accessoryView = ratingStepper

        priceStepper.minimumValue = 1
        priceStepper.maximumValue = 4
        priceStepper.stepValue = 1
        priceStepper.value = 2
        priceStepper.addAction(UIAction { [weak self] _ in self?.updateStepperLabels() },
                               for: .valueChanged)
        priceCell.textLabel?.text = "Price"
        priceCell.accessoryView = priceStepper

        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        embed(datePicker, in: dateCell)

        [nameCell, categoryCell, ratingCell, priceCell, dateCell, notesCell].forEach {
            $0.selectionStyle = .none
        }
        updateStepperLabels()
    }

    /// Pins `view` to the cell's content margins.
    private func embed(_ view: UIView, in cell: UITableViewCell) {
        view.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(view)
        let margins = cell.contentView.layoutMarginsGuide
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: margins.topAnchor),
            view.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        ])
    }

    private func updateStepperLabels() {
        ratingCell.detailTextLabel?.text = String(format: "★ %.1f", ratingStepper.value)
        priceCell.detailTextLabel?.text = String(repeating: "$", count: Int(priceStepper.value))
    }

    /// Edit mode: fill the inputs with the existing place's values.
    private func configureForEditing() {
        guard let place else { return }

        nameField.text = place.name
        notesField.text = place.notes
        if let row = PlaceCategory.allCases.firstIndex(of: place.category) {
            categoryPicker.selectRow(row, inComponent: 0, animated: false)
        }
        ratingStepper.value = place.rating
        priceStepper.value = Double(place.priceLevel)
        datePicker.date = place.lastVisited
        updateStepperLabels()
    }

    // MARK: - Save

    private func saveTapped() {
        let name = nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !name.isEmpty else {
            let alert = UIAlertController(title: "Name required",
                                          message: "Please enter a name for this place.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        let category = PlaceCategory.allCases[categoryPicker.selectedRow(inComponent: 0)]
        let notes = notesField.text ?? ""

        if let place {
            // Editing: mutate the shared instance directly (pass by reference).
            let updatedPlace = Place(
                id: place.id,
                name: name,
                category: category,
                rating: ratingStepper.value,
                priceLevel: Int(priceStepper.value),
                lastVisited: datePicker.date,
                notes: notes
            )
            delegate?.didUpdatePlace(updatedPlace)
        } else {
            let newPlace = Place(name: name,
                                 category: category,
                                 rating: ratingStepper.value,
                                 priceLevel: Int(priceStepper.value),
                                 lastVisited: datePicker.date,
                                 notes: notes)
            delegate?.didAddPlace(newPlace)
        }
        dismiss(animated: true)
    }

    // MARK: - UITableViewDataSource

    private func cells(in section: Section) -> [UITableViewCell] {
        switch section {
        case .name:        return [nameCell]
        case .category:    return [categoryCell]
        case .details:     return [ratingCell, priceCell]
        case .lastVisited: return [dateCell]
        case .notes:       return [notesCell]
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        Section(rawValue: section)?.title
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        return cells(in: section).count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        return cells(in: section)[indexPath.row]
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch Section(rawValue: indexPath.section) {
        case .category, .lastVisited: return 200
        default:                      return UITableView.automaticDimension
        }
    }
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate

extension PlaceFormViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        PlaceCategory.allCases.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        PlaceCategory.allCases[row].rawValue
    }
}
