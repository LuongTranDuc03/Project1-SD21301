package project.duan1_sd21301.repository.phuc;

import project.duan1_sd21301.dto.phuc.AttributeDTO;

import java.util.List;

public interface AttributeRepository {
    List<AttributeDTO> findAll(String type);
    List<AttributeDTO> findAll(String type, int page, int size);
    long countAll(String type);
    AttributeDTO findById(String type, int id);
    boolean insert(String type, AttributeDTO dto);
    boolean update(String type, AttributeDTO dto);
    String generateNextCode(String type);
}
