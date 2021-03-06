#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Возвращает список реквизитов, которые разрешается редактировать
// с помощью обработки группового изменения объектов.
//
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	РедактируемыеРеквизиты = Новый Массив;
	
	РедактируемыеРеквизиты.Добавить("Пол");
	
	Возврат РедактируемыеРеквизиты;
	
КонецФункции

// Возвращает описание блокируемых реквизитов
// Возвращаемое значение: массив
// Элемент массива: строка в формате
//		ИмяРеквизита[;ИмяЭлементаФормы,...]
// где	ИмяРеквизита - имя реквизита объекта
//		ИмяЭлементаФормы - имя элемента формы, связанного с реквизитом
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	БлокируемыеРеквизиты = Новый Массив;
	
	БлокируемыеРеквизиты.Добавить("ДатаРождения");
	БлокируемыеРеквизиты.Добавить("КодСинхронизации");
	//АсТБ_Alexey_113864_********************************************************************
	БлокируемыеРеквизиты.Добавить("Texel_ID");
	//АсТБ_Alexey_113864_********************************************************************
	
	Возврат БлокируемыеРеквизиты;
	
КонецФункции

#КонецЕсли