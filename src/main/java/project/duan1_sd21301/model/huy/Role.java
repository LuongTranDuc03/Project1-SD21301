package project.duan1_sd21301.model.huy;

public class Role {
    private int id;
    private String roleName;

    private int status; // 1: Active, 0: Inactive

    public Role() {
    }

    public Role(int id, String roleName, int status) {
        this.id = id;
        this.roleName = roleName;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }



    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }
}
