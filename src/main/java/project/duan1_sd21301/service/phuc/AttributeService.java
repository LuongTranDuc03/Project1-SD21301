package project.duan1_sd21301.service.phuc;

import project.duan1_sd21301.dto.phuc.AttributeDTO;

import java.util.List;

public interface AttributeService {
    List<AttributeDTO> findAll(String type);
    List<AttributeDTO> findAll(String type, int page, int size);
    long countAll(String type);
    AttributeDTO findById(String type, int id);
    boolean save(String type, AttributeDTO dto);
    boolean toggleStatus(String type, int id);
    String generateNextCode(String type);
}
