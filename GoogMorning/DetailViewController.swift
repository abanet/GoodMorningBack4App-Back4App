//
//  DetailViewController.swift
//  GoogMorning
//
//  Created by Alberto Banet Masa on 27/2/15.
//  Copyright (c) 2015 Alberto Banet Masa. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, protocoloParseFrases {

    @IBOutlet var viewFotoBuenosDias: UIImageView!
    @IBOutlet var frase: UILabel!
    @IBOutlet weak var btnCompartir: UIBarButtonItem!
    
    var fotoSegue: PFObject?
    fileprivate var parseFrases: ParseFrases!
    fileprivate var animacionMarcha: Bool!
    fileprivate var siguienteAnimacionTextoOn: Bool!
    fileprivate var autorFrase: String?
    
    
    override func viewDidLoad() {
        parseFrases = ParseFrases()
        parseFrases.delegate = self
        animacionMarcha = false
        siguienteAnimacionTextoOn = true
        self.frase.text = ""
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.btnCompartir.isEnabled = false
        self.frase.alpha = 0
        self.viewFotoBuenosDias.alpha = 0
        
        if let objetoSegue = fotoSegue {
           // frase.text = objetoSegue["fraseEng"] as String!
            let imagenPFFile = objetoSegue["foto"] as! PFFile
            imagenPFFile.getDataInBackground {
                (imageData: Data?, error: Error?)-> Void in
                if error == nil {
                  if let imageData = imageData {
                     let image = UIImage(data:imageData)
                      self.viewFotoBuenosDias.image = image
                      self.btnCompartir.isEnabled = true
                  } // if let imageData
                } // if error == nil
              } // getDataInBackgroundWithBlock
            } // let objetoSegue
      } // func
  
        


    // Compartir imagen y frase con las redes sociales
    @IBAction func compartirRedesSociales(_ sender: AnyObject) {
        
        let wsActivity = MMMWhatsAppActivity() // actividad de whatsapp
        
        let fraseYautor: String = self.frase.text! + " [\(autorFrase!)]"
        let objetosACompartir: [AnyObject?] = [fraseYautor as ImplicitlyUnwrappedOptional<AnyObject>, self.viewFotoBuenosDias.image, URL(string: NSLocalizedString("appURL", comment:"url de la app en el applestore")) as Optional<AnyObject>]
        let activityController = UIActivityViewController(activityItems: objetosACompartir, applicationActivities: [wsActivity])
        activityController.excludedActivityTypes =  [
            UIActivityType.postToWeibo,
            UIActivityType.assignToContact,
            UIActivityType.saveToCameraRoll,
            UIActivityType.addToReadingList]
        self.present(activityController, animated: true, completion: nil)    }
    
    
    func animarTextoDurante(_ segundos: TimeInterval, delay: TimeInterval, alfaFinal: CGFloat){
        self.animacionMarcha = true
        UIView.animate(withDuration: segundos, delay: delay, options: [], animations: {
            self.frase.alpha = alfaFinal
            }, completion: {(completed: Bool) in
                if(completed){
                    self.animacionMarcha = false
                }
                return
        })
    }
    
    func animarImagenDurante(_ segundos: TimeInterval, delay: TimeInterval, alfaFinal: CGFloat){
        self.animacionMarcha = true
        UIView.animate(withDuration: segundos, delay: delay, options:[], animations: {
            self.viewFotoBuenosDias.alpha = alfaFinal
            }, completion: {(completed: Bool) in
                if(completed){
                    self.animacionMarcha = false
                }
                return
        })
    }
    
    // Se han cargado las frases. Elegimos una y la mostramos.
    func frasesCargadas() {
        //let blur = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Light))
        //blur.frame = view.frame
        //view.addSubview(blur)
        (self.frase.text, autorFrase) = parseFrases.escogerUnaFraseAlAzar()
        
        animarTextoDurante(3.0, delay:0.0, alfaFinal: 1.0)
        animarImagenDurante(3.0, delay: 3.0, alfaFinal: 1.0)
        animarTextoDurante(3.0, delay: 3.0, alfaFinal: 0.0)
    }
    
   override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(!self.animacionMarcha){
            if(!self.siguienteAnimacionTextoOn){
                animarTextoDurante(3.0, delay: 0.0 , alfaFinal: 0.0)
                animarImagenDurante(3.0, delay: 0.0, alfaFinal: 1.0)
            } else {
                animarTextoDurante(3.0, delay: 0.0 , alfaFinal: 1.0)
                animarImagenDurante(3.0, delay: 0.0, alfaFinal: 0.0)
            }
            siguienteAnimacionTextoOn = !siguienteAnimacionTextoOn
        }
    }
    
   
}
