import UIKit
import CoreData

class DownloadRepository {
    static let shared = DownloadRepository()
    
    func addToDownload(title:Title, callback:@escaping(Result<Void, Error>) -> Void){
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
            callback(.failure(DBError.FAILED_TO_SAVE))
            return
        }
        let context = appdelegate.persistentContainer.viewContext
        
        let titleEntity = TitleEntity(context: context)
        titleEntity.id = Int64(title.id)
        titleEntity.photo_path = title.poster_path ?? ""
        titleEntity.title = title.titleName
        
        do {
            try context.save()
            callback(.success(()))
        } catch {
            callback(.failure(DBError.FAILED_TO_SAVE))
        }
    }
    
    func deleteFromDownload(title: TitleEntity, callback:@escaping(Result<Void, Error>) -> Void){
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
            callback(.failure(DBError.FAILED_TO_DELETE))
            return
        }
        let context = appdelegate.persistentContainer.viewContext
        context.delete(title)
        do {
            try context.save()
            callback(.success(()))
        } catch{
            callback(.failure(DBError.FAILED_TO_DELETE))
        }
    }
    
    
    func fetchDownloadList(callback:@escaping(Result<[TitleEntity], Error>) -> Void){
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
            callback(.failure(DBError.FAILED_TO_FETCH_LIST))
            return
        }
        
        let context = appdelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TitleEntity> = TitleEntity.fetchRequest()
        
        do{
            let downloadList = try context.fetch(request)
            callback(.success(downloadList))
        } catch {
            callback(.failure(DBError.FAILED_TO_FETCH_LIST))
        }
    }
}
