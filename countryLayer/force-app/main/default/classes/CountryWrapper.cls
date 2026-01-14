public class CountryWrapper {
    public String name {get; set;}
    public String alpha2Code {get; set;}
    public String alpha3Code {get; set;}
    public String capital {get; set;}
    public String region {get; set;}
    public List<RegionalBloc> regionalBlocs {get; set;}  
    
    public class RegionalBloc {
        public String name {get; set;}
        public String acronym {get; set;}
    }
    
    public static List<CountryWrapper> parse(String json) {
        return (List<CountryWrapper>) System.JSON.deserialize(json, List<CountryWrapper>.class);
    }
}