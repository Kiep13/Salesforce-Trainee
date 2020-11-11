public with sharing class FieldChanges {
    public String fieldName;
    public Object oldValue;
    public Object newValue;

    public FieldChanges(String fieldName,Object oldValue,Object newValue) {
        this.fieldName = fieldName;
        this.oldValue = oldValue;
        this.newValue = newValue;
    }
}
