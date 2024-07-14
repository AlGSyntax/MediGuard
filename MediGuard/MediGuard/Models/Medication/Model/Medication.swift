//
//  Medication.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 13.06.24.
//

import Foundation
import FirebaseFirestoreSwift

// MARK: - Medication Modell

/**
 Die `Medication`-Struktur repräsentiert ein Medikament mit seinen Details wie Name, Einnahmezeit, Dosierung, etc.
 
 Dieses Modell wird verwendet, um Informationen über Medikamente in der Anwendung zu speichern und zu verwalten.
 
 - Eigenschaften:
    - `id`: Die eindeutige Kennung für das Medikament, die von Firebase generiert wird.
    - `name`: Der Name des Medikaments.
    - `intakeTime`: Die Uhrzeit, zu der das Medikament eingenommen werden soll.
    - `day`: Der Wochentag, an dem das Medikament eingenommen werden soll.
    - `nextIntakeDate`: Das nächste geplante Einnahmedatum und -zeit (optional).
    - `color`: Die Farbe, die dem Medikament zugewiesen ist, um es visuell zu unterscheiden.
    - `dosage`: Die Dosierung des Medikaments.
    - `dosageUnit`: Die Einheit der Dosierung (z.B. mg, ml).
    - `daily`: Eigenschaft für tägliche Einnahme.
 */
struct Medication: Identifiable, Codable,Hashable {
    @DocumentID var id: String?
    var name: String
    var intakeTime: DateComponents
    var day: Int?
    var nextIntakeDate: DateComponents?
    var color: MedicationColor
    var dosage: Int
    var dosageUnit: DosageUnit
    var daily : Bool
    
    /**
     Initialisiert eine neue `Medication`-Instanz.
     
     - Parameter id: Die eindeutige Kennung des Medikaments (optional).
     - Parameter name: Der Name des Medikaments.
     - Parameter intakeTime: Die Uhrzeit, zu der das Medikament eingenommen werden soll.
     - Parameter day: Der Wochentag, an dem das Medikament eingenommen werden soll.
     - Parameter nextIntakeDate: Das nächste geplante Einnahmedatum und -zeit (optional).
     - Parameter color: Die Farbe, die dem Medikament zugewiesen ist.
     - Parameter dosage: Die Dosierung des Medikaments.
     - Parameter dosageUnit: Die Einheit der Dosierung (z.B. mg, ml).
     */
    init(id: String? = nil, name: String, intakeTime: DateComponents, day: Int, nextIntakeDate: DateComponents?, color: MedicationColor, dosage: Int, dosageUnit: DosageUnit, daily: Bool = false) {
        self.id = id
        self.name = name
        self.intakeTime = intakeTime
        self.day = day
        self.nextIntakeDate = nextIntakeDate
        self.color = color
        self.dosage = dosage
        self.dosageUnit = dosageUnit
        self.daily = daily 
    }
}


