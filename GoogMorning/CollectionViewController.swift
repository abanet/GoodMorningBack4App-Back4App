//
//  CollectionViewController.swift
//  GoogMorning
//
//  Created by Alberto Banet Masa on 26/2/15.
//  Copyright (c) 2015 Alberto Banet Masa. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController, protocoloParseFotos {

    fileprivate let reuseIdentifier = "Cell"
    fileprivate var objetosFotos = [PFObject]()
    fileprivate var parseFotos: ParseFotos!
    fileprivate var listaFotos: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         // Ajustamos ancho de la celda
        let ancho = collectionView!.frame.width/3
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: ancho, height: ancho*1.5)
        
        // Ponemos el título
        self.navigationItem.title = NSLocalizedString("Elige cómo dar los buenos días!", comment: "Título del navigation controller en el collection view controller.")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        parseFotos = ParseFotos()
        parseFotos.delegate = self
        self.objetosFotos = parseFotos.arrayFotos
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("número de objetosFotos: \(parseFotos.numFotos)")
        return parseFotos.numFotos
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)as! GoodMorningViewCell
        cell.index = indexPath
        cell.layer.shouldRasterize = true;
        cell.layer.rasterizationScale = UIScreen.main.scale
        
        // Descargar la imagen a mostrar
        let buenosDiasActual = objetosFotos[indexPath.row] as PFObject
        let imagenFile = buenosDiasActual["foto"] as! PFFile
        imagenFile.getDataInBackground {
            (imageData: Data?, error: Error?)-> Void in
            if error == nil {
              if let imageData = imageData {
                 let image = UIImage(data:imageData)
                if cell.index == indexPath {
                  cell.imagenView.image = image
                }
                }
            }
        }
        return cell
    }
    
    func fotosCargadas() {
        if let coleccion = self.collectionView {
            DispatchQueue.main.async {
                self.objetosFotos = self.parseFotos.arrayFotos
                coleccion.reloadData()
        }
        }
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let buenosDiasActual = objetosFotos[indexPath.row]
        performSegue(withIdentifier: "MasterToDetail", sender: buenosDiasActual)
    }
    
    // MARK: Preparando Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MasterToDetail" {
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.fotoSegue = sender as? PFObject
        }
    }
}
