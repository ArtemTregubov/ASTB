////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму(
		"Обработка.ПанельАдминистрированияАсТБ.Форма.НастройкаАСТБ",
		Новый Структура,
		ПараметрыВыполненияКоманды.Источник,
		"Обработка.ПанельАдминистрированияАсТБ.Форма.НастройкаАСТБ" + ?(ПараметрыВыполненияКоманды.Окно = Неопределено, ".ОтдельноеОкно", ""),
		ПараметрыВыполненияКоманды.Окно
	);
	
КонецПроцедуры
