import 'dart:io';

List products = [
  'Noutbuk Asus',
  'Telefon Samsung',
  'Kondisioner Mitsubishi',
  'Paltaryuyan',
  'Stol'
];
List productInfo = [
  'Core i9 13900K, Ram 32GB DDR5, SSD 1TB, VideoKart Geforce 4060',
  'Telefon Samsung, Snapdragon 880, Ram 8gb',
  'Kondisioner Mitsubishi, Rengi ag, KvadratMetr 200',
  'Paltaryuyan, 10kg- qeder, Smart ',
  'Stol, Eboksid, 5x15 m., 1 m'
];
List productPrice = [2000, 1000, 800, 500, 200];

int? intParse = 0;
int productIndex = 0;
int servicePrice = -1;
String paymentType = '';
String password = '';
String userName = '';
double endPrice = 0;
String result = '';
main() {
  if (loginProcedure()) {
    listProducts(false);
    if (userName != 'guest') {
      print('Davam etmək istəyirsiniz? Bəli | Xeyir');
      if (stdin.readLineSync().toString().toLowerCase().startsWith('b')) {
        listProducts(true);
        print('Xahiş olunur məhsulun indeksini qeyd edin:');
        intParse = int.tryParse(stdin.readLineSync().toString());
        if (intParse != null) {
          productIndex = intParse!;
          if (productIndex > products.length || productIndex <= 0) {
            errorMessage('sechim');
          } else {
            servicePrice = bringType();
            if (servicePrice > -1) {
              endPrice = paymentTypeFunction();
              if (endPrice > 0) {
                if (servicePrice == 0) {
                  print(
                      'Yekun odeme $endPrice AZN, Malin deyeri: ${productPrice[productIndex - 1]} aa');
                } else {
                  print(
                      'Yekun odeme ${endPrice + servicePrice} AZN, Malin deyeri: ${productPrice[productIndex - 1]} chatdirilma: $servicePrice');
                }
              } else {
                errorMessage('');
              }
            }
          }
        } else {
          errorMessage('sechim');
        }
      }
    } else {
      print('Hər hansı bir məhsulu seçmək üçün, giriş etməyiniz xahiş olunur');
    }
  }
}

bool cardInfo() {
  print('Kartın məlumatlarını qeyd edin');
  if (stdin.readLineSync().toString().length < 16) {
    errorMessage('card');
    return false;
  }
  return true;
}

double bankPayment() {
  print('Uygun olan odəmə şərtlərini seçin: 3, 6, 18, 24 ay');
  int payCount = int.parse(stdin.readLineSync().toString());
  print('$payCount ayliq odeme sechilmishdir 25%-le');
  return productPrice[productIndex - 1] * 1.25;
}

double paymentTypeFunction() {
  print('Ödəmə növünü seçin: Nağd | Kartla');
  paymentType = stdin.readLineSync().toString().toLowerCase();
  if (paymentType.startsWith('n')) {
    return productPrice[productIndex - 1];
  } else if (paymentType.startsWith('k')) {
    print('Kartla ödəmə üsulunu seçin: Birbaşa | Taksit');
    result = stdin.readLineSync().toString().toLowerCase();
    if (result.startsWith('b')) {
      return cardInfo() ? productPrice[productIndex - 1] : 0;
    } else if (result.startsWith('t')) {
      return bankPayment();
    } else {
      errorMessage('sechim');
    }
  } else {
    errorMessage('sechim');
  }
  return 0;
}

int bringType() {
  print('Malın alınma növünü seçin : Chatdırılma | Shəxsən');
  result = stdin.readLineSync().toString().toLowerCase();
  if (result.startsWith('s')) {
    return 0;
  } else if (result.startsWith('c')) {
    return 10;
  } else {
    errorMessage('sechim');
    return -1;
  }
}

bool loginProcedure() {
  print(
      'Xosh gelmisiniz \nQeydiyyatdan kechmisinizse istifadechi adini daxil edin ve ya guest kimi davam edin');
  userName = stdin.readLineSync().toString();
  if (userName.isEmpty || userName.contains(' ')) {
    errorMessage('login');
    return false;
  } else {
    if (userName != 'guest') {
      print('Istifadəçi şifrəsini qeyd edin:');
      password = stdin.readLineSync().toString();
      if (password.length < 8) {
        errorMessage('password');
        return false;
      }
    }
  }
  return true;
}

void errorMessage(String type) {
  String message = '';
  switch (type) {
    case 'login':
      message = 'Istifadəçi adında yalnışlıq';
      break;
    case 'password':
      message = 'Şifrə yalnışdır və ya simvol sayi 8-dən aşağıdır';
      break;
    case 'sechim':
      message = 'Seçiminiz yalnışdır və ya qeyd olunan indeks mövcud deyil';
      break;
    case 'card':
      message = 'kart məlumatları yalnışdır';
      break;
    default:
      message = 'Naməlum səhv';
  }
  print(message);
}

void listProducts(bool fullInfo) {
  for (int i = 0; i < products.length; i++) {
    if (fullInfo) {
      print(
          '${i + 1}: ${products[i]} (${productInfo[i]}) - ${productPrice[i]} AZN');
    } else {
      print('${i + 1}: ${products[i]}');
    }
  }
}
