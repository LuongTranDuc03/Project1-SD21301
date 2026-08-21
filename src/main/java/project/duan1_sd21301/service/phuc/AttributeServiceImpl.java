package project.duan1_sd21301.service.phuc;

import project.duan1_sd21301.dto.phuc.AttributeDTO;
import project.duan1_sd21301.repository.phuc.AttributeRepository;
import project.duan1_sd21301.repository.phuc.AttributeRepositoryImpl;

import java.text.Normalizer;
import java.util.List;

public class AttributeServiceImpl implements AttributeService {

    private final AttributeRepository attributeRepository = new AttributeRepositoryImpl();

    @Override
    public List<AttributeDTO> findAll(String type) {
        return attributeRepository.findAll(type);
    }

    @Override
    public List<AttributeDTO> findAll(String type, int page, int size) {
        return attributeRepository.findAll(type, page, size);
    }

    @Override
    public long countAll(String type) {
        return attributeRepository.countAll(type);
    }

    @Override
    public AttributeDTO findById(String type, int id) {
        return attributeRepository.findById(type, id);
    }

    @Override
    public boolean save(String type, AttributeDTO dto) {
        if (dto.getName() != null) {
            String newName = Normalizer.normalize(dto.getName().trim().replaceAll("\\s+", " "), Normalizer.Form.NFC);
            List<AttributeDTO> allAttr = attributeRepository.findAll(type);
            for (AttributeDTO existing : allAttr) {
                if (existing.getName() != null) {
                    String existingName = Normalizer.normalize(existing.getName().trim().replaceAll("\\s+", " "), Normalizer.Form.NFC);
                    if (existingName.equalsIgnoreCase(newName)) {
                        if (dto.getId() <= 0 || existing.getId() != dto.getId()) {
                            throw new RuntimeException("Tên thuộc tính đã tồn tại!");
                        }
                    }
                }
            }
        }

        if (dto.getCode() == null || dto.getCode().trim().isEmpty()) {
            dto.setCode(generateNextCode(type));
        }
        if (dto.getId() > 0) {
            return attributeRepository.update(type, dto);
        } else {
            return attributeRepository.insert(type, dto);
        }
    }

    @Override
    public boolean toggleStatus(String type, int id) {
        AttributeDTO dto = attributeRepository.findById(type, id);
        if (dto != null) {
            int newStatus = (dto.getStatus() == null || dto.getStatus() == 0) ? 1 : 0;
            dto.setStatus(newStatus);
            return attributeRepository.update(type, dto);
        }
        return false;
    }

    @Override
    public String generateNextCode(String type) {
        return attributeRepository.generateNextCode(type);
    }
}
