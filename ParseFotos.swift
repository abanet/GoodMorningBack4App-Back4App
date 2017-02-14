//
//  ParseFotos.swift
//  GoogMorning
//
//  Created by Alberto Banet Masa on 26/2/15.
//  Copyright (c) 2015 Alberto Banet Masa. All rights reserved.
//

import UIKit

protocol protocoloParseFotos
{
     func fotosCargadas()
}

class ParseFotos {
    
    var arrayFotos: [PFObject] = []
    var numFotos: Int {
        get {
            return arrayFotos.count
        }
    }
    var delegate:protocoloParseFotos?
    
    init (){
        cargarFotos()
    }
    
    // Cargamos la tabla de fotos.
    // De momento cargamos todas. Después habrá que parametrizar para cargar las de un día, o un año, etc
    func cargarFotos() {
       
      // Clase Buenos días
      let query = PFQuery(className:"GoodMorning");
        
        // día de la semana para obtener sólo las fotos correspondientes al día que es hoy
        if let numeroDia = getDayOfWeek() {
            if let literalDia = nombreDiaSemanaNumero(numeroDia) {
                query.whereKey("dia", equalTo:literalDia)
            }
        }
        query.whereKey("visible", equalTo:true)
        query.cachePolicy = .networkElseCache
        query.order(byDescending: "updatedAt")
        query.findObjectsInBackground {
            (objects:[PFObject]?, error:Error?)-> Void in
            
            if error == nil {
                // The find succeeded.
                //NSLog("Successfully retrieved \(objects.count) scores.")
                // Do something with the found objects
              if let objects = objects {
                for object in objects {
                    //NSLog("%@", object.objectId)
                    self.arrayFotos.append(object)
                }
                self.delegate?.fotosCargadas()
              }
            } else {
                // Log details of the failure
                //NSLog("Error: %@ %@", error, error.userInfo)
            }
        
        }
        
    }
    
    func goodMorningForIndexPath(_ indexPath: IndexPath) -> PFObject {
        return arrayFotos[indexPath.row]
    }
    
    func getDayOfWeek()->Int? {
        let myCalendar = Calendar(identifier: .gregorian)
        let myComponents = (myCalendar as NSCalendar?)?.components(NSCalendar.Unit.NSWeekdayCalendarUnit, from: Date())
        let weekDay = myComponents?.weekday
        return weekDay
    }
    
    func nombreDiaSemanaNumero(_ numerodia:Int)->String? {
        switch numerodia{
        case 1:
            return "domingo"
        case 2:
            return "lunes"
        case 3:
            return "martes"
        case 4:
            return "miércoles"
        case 5:
            return "jueves"
        case 6:
            return "viernes"
        case 7:
            return "sábado"
        default:
            return nil
        }
    }
    
}
