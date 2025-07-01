import Foundation

class WeatherViewModel: ObservableObject{ //paylaşılabilyor bir nesne =class ViewModeli View'a aktarmamızı sağlayacak
    @Published var city:String = ""    //@Published Bu değişken dinlenir yani değişirse SwiftUI otomatik güncellenir y
    @Published var temperature:String = ""
    @Published var description:String = ""
    
    func fetchWeather(){ //apiden veri çeker
        let apiKey = "YOUR_API_KEY" //api key
        let query = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //şehir isimlerindeki düzenlemeleri ayarlıyor türkçe karakter ya da boşluk olabilir onları düzeltiyor
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(query)&appid=\(apiKey)&units=metric" //apikey ve şehir adı ile tam url oluştu unit=metric ile celcius seviyesine ayarlama
        
        guard let url = URL(string: urlString) else {return}  //urlstring metibn biz onu nesneye çeviriyoruz
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in //URLSession swiftin internete istek atmasını sağlayan sınıf
            if let data = data{//veri gelirse işle
                if let decoded = try? JSONDecoder().decode(WeatherResponse.self, from: data){
                    DispatchQueue.main.async { //UI'yı güncellemek için ana kuyruğa dönüş
                        self.temperature="\(decoded.main.temp)°C"
                        self.description=decoded.weather.first?.description.capitalized ?? "-" //jsondan gelen verileri formatlayarak @Published değişkenine aktarıyor
                    }
                }
                else {
                    print("json çzöümleme başarısız")
                    
                }
            }else if let error = error{
                    print("api hatası \(error.localizedDescription)")
                }
            }
        .resume()

        }
    }

