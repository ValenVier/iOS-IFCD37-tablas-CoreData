//
//  ViewController.swift
//  tablas
//
//  Created by Javier Rodríguez Valentín on 24/09/2021.
//

import UIKit

class ViewController: UIViewController{
    
    //var array = ["Valladolid","Palencia","Segovia","Salamanca","Madrid"]
    var array:[Ciudad] = []
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var addBtnOut: UIButton!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var input: UITextField!
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self //nos mete el UITableViewDataSource que lo metemos en una excepción
        table.delegate = self//nos mete el UITableViewDelegate que lo metemos en una excepción
        
        table.tableFooterView = UIView() //no muestra nada por debajo de la última fila
        
        addBtnOut.layer.cornerRadius = 15
        addBtnOut.titleLabel?.font = .systemFont(ofSize: 25)
        addBtnOut.setTitle("Añadir", for: .normal)
        addBtnOut.backgroundColor = UIColor(red: 0/255, green: 128/255, blue: 254/255, alpha: 1.0)
        addBtnOut.tintColor = .white
        
        label.text = "Escriba sus ciudades"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22)
        
        getData()
    }
    
    //MARK: addBtn - guardar datos
    @IBAction func addBtn(_ sender: Any) {
        
        if input.text != "" {
            
            let ciudadAdd = Ciudad(context: self.context)
            
            ciudadAdd.nombre = input.text
            
            do {
                try self.context.save()
                self.getData()
            } catch {
                //print("ERROR: al guardar datos")
                alert(msg: "ERROR: al guardar datos", a: 00)
            }
            
        }else{
            //print("No hay ningun dato insertado")
            alert(msg: "No hay ningun dato insertado", a: 0)
        }
    }
    
//MARK: getData
    func getData() {
        
        do {
            self.array = try context.fetch(Ciudad.fetchRequest())
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        } catch {
            //print("ERROR: al obtener datos")
            alert(msg: "ERROR: al obtener datos", a: 0)
        }
    }
    
//MARK: Alert
    func alert(msg:String, a:Int){
        
        if a == 0{
            //print("errores")
            let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            present(alert, animated: true, completion: {/*Para poner el temporizador, se puede poner nil*/ Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: {_ in
                self.dismiss(animated: true, completion: nil)
            })})
        }else if a == 1{
            //print("modificar")
            //al final esta parte no se utiliza porque se hace la parte de modificar en la extansión del delegate
        }else{
            //print("ERROR GRAVE, GRAVISIMO")
            let alert = UIAlertController(title: "Alert", message: "ERROR GRAVE, GRAVISIMO", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            present(alert, animated: true, completion: {/*Para poner el temporizador, se puede poner nil*/ Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: {_ in
                self.dismiss(animated: true, completion: nil)
            })})
        }
        
        
    }
    
}

//con el comentario con mark hacemos que se pueda buscar las palabras de después del comentario en la jerarquía de busqueda
//MARK: extension DataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //Las secciones nos hacen la tabla completa (si == 0 una vez, pero si es mayor que 0 más veces) y el resto de secciones que pongamos (en la funcion de secciones) nos lo hace poniendo solo los elementos que digamos en este caso 2
        /*if section == 0 {
         return array.count
         }else{
         return 2
         
         }*/
        
        return array.count
        
    }
    
//MARK: Constructor Celda
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = table.dequeueReusableCell(withIdentifier: "celda") //
        
        if cell == nil{
            //si la celda no existe se crea con el método constructor
            cell = UITableViewCell(style: .default, reuseIdentifier: "celda")
            
            //aquí podemos cambiar propiedades de la tabla
            cell?.textLabel?.font = .systemFont(ofSize: 20)
            cell?.accessoryType = .disclosureIndicator
            cell?.backgroundColor = .cyan
            cell?.tintColor = .red
            
        }
        
        cell?.textLabel!.text = array[indexPath.row].nombre
        return cell!
        
    }
    
}


//MARK: extensión delegate
extension ViewController: UITableViewDelegate{
    //esta función nos dice el elemento seleccionado
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Has seleccionado: \(array[indexPath.row])")
    }
    
    //nº de veces que nos repite la tabla
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
//MARK: eliminar o modificar
//Eliminamos arrastrando el elemento hacia la izquierda con leadingSwipeActionsConfigurationForRowAt
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //parte de borrar
        let action = UIContextualAction(style: .destructive, title: "BORRAR") { [self](action,view,completionHandler) in
            let eraseCiudad = self.array[indexPath.row]
            self.context.delete(eraseCiudad)
            do {
                try self.context.save()
            } catch {
                //print("ERROR: al borrar datos")
                alert(msg: "ERROR: al borrar datos", a: 0)
            }
            self.getData()
        }
        
        //parte de modificar
        let action2 = UIContextualAction(style: .normal, title: "Modificar") { /*[self] -> si pongo este self entre corchetes no necesitaría poner en el código de esta función la palabra self antes de cada variable*/ _,_,_ in
            //selecciono un elemento del array
            let modifyCiudad = self.array[indexPath.row]
            //creo una alerta
            let alert2 = UIAlertController(title: "Modificar", message: "Elemento a editar", preferredStyle: .alert)
            //añado un campo de texto
            alert2.addTextField()
            //creo el campo de texto que le digo ue va a ser el primero [0]
            let textField = alert2.textFields![0]
            //Escribe en el textField de la alerta el contenido de la celda seleccionada
            textField.text = modifyCiudad.nombre
            //creo una acción dentro de la alerta en forma de botón
            let action2Alerta = UIAlertAction(title: "OK", style: .default) { (_) in
                //creo un textField y le pongo el contenido de la alerta
                let textField2 = alert2.textFields![0]
                modifyCiudad.nombre = textField2.text
                do {
                    try self.context.save()
                    self.getData()
                } catch {
                    //print("Error al eliminar un objeto")
                    self.alert(msg: "Error al modificar un objeto", a: 0)
                }
            }
                //añado la accion a la alerta
                alert2.addAction(action2Alerta)
            
            //añado un nuevo botón de cancelar
            let cancelButton = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
            alert2.addAction(cancelButton)
                
                //presento la alerta
            self.present(alert2, animated: true, completion: nil)
            
        }
        action2.backgroundColor = .darkGray
        
        return UISwipeActionsConfiguration(actions: [action2,action])
    }
    
}
