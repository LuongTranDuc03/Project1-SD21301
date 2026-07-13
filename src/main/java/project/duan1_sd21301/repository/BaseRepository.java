package project.duan1_sd21301.repository;

import java.util.List;

/**
 * Interface Repository cơ sở định nghĩa các thao tác CRUD cơ bản.
 * @param <T> Kiểu Entity/Model (Ví dụ: Product, User, Invoice)
 * @param <ID> Kiểu dữ liệu của Khóa chính (Ví dụ: Integer, String)
 */
public interface BaseRepository<T, ID> {
    
    List<T> findAll();
    
    T findById(ID id);
    
    boolean insert(T entity);
    
    boolean update(T entity);
    
    boolean delete(ID id);
}
