//
//  ImagePicker.swift
//  MediGuard
//
//  Created by Alvaro Guillermo del Castillo Forero on 21.06.24.
//

import SwiftUI
import UIKit

/**
 Eine Struktur zur Darstellung eines Bildauswahlers, der das UIImagePickerController-UI von UIKit verwendet.
 
 Diese Struktur ermöglicht es dem Benutzer, ein Bild aus der Fotobibliothek auszuwählen und dieses Bild in einer SwiftUI-Ansicht anzuzeigen.
 
 - Properties:
    - image: Ein Binding zu einem optionalen UIImage, das das ausgewählte Bild enthält.
 */
struct ImagePicker: UIViewControllerRepresentable {
    /// Ein Binding zu einem optionalen UIImage, das das ausgewählte Bild enthält.
    @Binding var image: UIImage?

    /**
     Ein Koordinator zur Verwaltung der UIImagePickerController-Delegiertenmethoden.
     
     Der Koordinator ist eine NSObject-Unterklasse und implementiert die UIImagePickerControllerDelegate- und UINavigationControllerDelegate-Protokolle.
     */
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        /// Eine Referenz auf den übergeordneten ImagePicker.
        var parent: ImagePicker

        /**
         Initialisiert einen neuen Koordinator.
         
         - Parameter parent: Der übergeordnete ImagePicker, der diesen Koordinator erstellt.
         */
        init(parent: ImagePicker) {
            self.parent = parent
        }

        /**
         Wird aufgerufen, wenn der Benutzer ein Bild ausgewählt hat.
         
         Diese Methode extrahiert das ausgewählte Bild aus den Info-Daten und weist es der `image`-Eigenschaft des übergeordneten ImagePicker zu.
         
         - Parameter picker: Der UIImagePickerController, der das Bild ausgewählt hat.
         - Parameter info: Ein Dictionary, das die Bildinformationen enthält.
         */
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }

            // Schließt den Bildauswähler
            picker.dismiss(animated: true)
        }

        /**
         Wird aufgerufen, wenn der Benutzer den Bildauswähler abbricht.
         
         Diese Methode schließt einfach den Bildauswähler, ohne Änderungen vorzunehmen.
         
         - Parameter picker: Der UIImagePickerController, der abgebrochen wurde.
         */
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            // Schließt den Bildauswähler
            picker.dismiss(animated: true)
        }
    }

    /**
     Erstellt einen neuen Koordinator für den ImagePicker.
     
     - Returns: Ein neuer Coordinator, der die Delegiertenmethoden verwaltet.
     */
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    /**
     Erstellt einen neuen UIImagePickerController und konfiguriert dessen Delegierten.
     
     - Parameter context: Der Kontext, der den Koordinator enthält.
     - Returns: Ein konfigurierter UIImagePickerController.
     */
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    /**
     Aktualisiert den UIImagePickerController.
     
     Diese Methode ist erforderlich, um das Protokoll `UIViewControllerRepresentable` zu erfüllen, wird aber in diesem Fall nicht verwendet.
     
     - Parameter uiViewController: Der zu aktualisierende UIImagePickerController.
     - Parameter context: Der Kontext, der den Koordinator enthält.
     */
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}


