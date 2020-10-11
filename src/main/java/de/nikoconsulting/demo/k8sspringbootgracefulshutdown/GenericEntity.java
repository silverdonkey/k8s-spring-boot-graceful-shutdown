package de.nikoconsulting.demo.k8sspringbootgracefulshutdown;

public class GenericEntity {

    private Long id;
    private String value;

    public GenericEntity(Long id, String value) {
        this.id = id;
        this.value = value;
    }

    public Long getId() {
        return id;
    }

    public String getValue() {
        return value;
    }
}
