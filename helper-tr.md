## Genel Bakış

Kodlama ve çözme işlemi, veri yapılarını bayt dizilerine dönüştürme ve bu bayt dizilerinden orijinal veri yapılarını yeniden oluşturma sürecidir. Bu işlemler, veri saklama ve iletimi sırasında verimlilik ve uyumluluk sağlar. Dart'ta bu işlemler için ByteData, Uint8List ve BytesBuilder gibi sınıflar kullanılır.

## Adım 1: Veri Tipi İşaretleyicileri

Her veri tipi için benzersiz bir işaretleyici (marker) belirledik. Bu, çözme sırasında veri tipini tanımlamak için kullanılır. Örneğin, bir integer değeri kodlamadan önce, bu değerin integer olduğunu belirten bir işaretleyici ekleriz.

## Adım 2: Veri Kodlama

Kodlama işlemi sırasında, her veri tipi için farklı bir kodlama yöntemi uygulanır:

- Integer: Varint(variable-length integer) kodlaması kullanılarak daha az yer kaplayacak şekilde kodlanır. Bu, özellikle büyük sayılar için verimliliği artırır.
- Double: Önceden belirlenmiş bir ölçek faktörü ile çarpılarak ölçeklenir ve sonuç, bir integer olarak kodlanır. Bu yöntem, double değerleri varint olarak kodlama imkanı tanır, ancak belirli bir hassasiyet kaybı olabilir.
- String: UTF-8 kodlaması kullanılarak bayt dizisine dönüştürülür. String uzunluğu varint olarak kodlanır ve ardından string baytları eklenir.
- List ve Map: Yapıları yineleyerek her elemanı sırasıyla kodlar. Bu koleksiyonların uzunlukları da varint olarak kodlanır.
- Bool: 1 veya 0 olarak kodlanır, bu da boolean değerinin doğru veya yanlış olduğunu temsil eder.

## Adım 3: Veri Çözme

Kodlanmış bayt dizisinden orijinal veri yapısını yeniden oluşturmak için çözme işlemi yapılır. Çözme işlemi sırasında, her veri tipi için işaretleyiciye göre uygun çözme yöntemi seçilir:

- Integer ve Double: Varint olarak kodlanmış değerler çözülür. Double için ek olarak, çözülen integer değeri ölçek faktörüne bölerek orijinal double değerine ulaşılır.
- String: İlk olarak string uzunluğu çözülür, ardından bu uzunlukta baytlar okunarak UTF-8 çözme işlemi ile orijinal stringe dönüştürülür.
- List ve Map: Uzunlukları çözüldükten sonra, bu uzunluk kadar eleman sırasıyla çözülerek orijinal yapıya dönüştürülür.
- Bool: 0 ise false, 1 ise true olarak çözülür.

## Varint(variable-length integer)

Variable-length integer, yani değişken uzunluklu tamsayı, sayının büyüklüğüne bağlı olarak farklı sayıda bayt kullanarak tamsayıları kodlamak için kullanılan bir yöntemdir. Bu kodlama şekli, özellikle veri sıkıştırma ve verimli veri saklama/aktarımı gibi durumlarda kullanılır. Değişken uzunluklu tamsayılar, genellikle küçük sayıları az sayıda bayt ile ve büyük sayıları daha fazla bayt kullanarak temsil eder, böylece tamsayı değerlerinin geniş bir yelpazesi dinamik olarak ve yerden tasarruf ederek kodlanabilir Örnek: Google Protobuf

## Sonuç

Bu süreçler, verilerin verimli bir şekilde saklanması ve iletilmesi için optimize edilmiştir. Double değerlerin ölçeklenmesi ve varint olarak kodlanması, bu veri tipinin de verimli bir şekilde saklanmasını sağlar, ancak kullanılan ölçek faktörüne göre bir hassasiyet kaybına neden olabilir. Bu yüzden ölçek faktörünü ihtiyaca göre belirlemek önemlidir.
