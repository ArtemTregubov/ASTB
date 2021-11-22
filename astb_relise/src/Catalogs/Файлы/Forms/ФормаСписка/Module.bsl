
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра(
		"ТекущийПользователь", Пользователи.ТекущийПользователь());
	
	РаботаСФайламиСлужебныйВызовСервера.ЗаполнитьУсловноеОформлениеСпискаФайлов(Список);
	
	ПриИзмененияИспользованияПодписанияИлиШифрованияНаСервере();
	
	Если ТекущийВариантИнтерфейсаКлиентскогоПриложения() = ВариантИнтерфейсаКлиентскогоПриложения.Версия8_2 Тогда
		Элементы.ФормаИзменить.Видимость = Ложь;
		Элементы.ФормаИзменить82.Видимость = Истина;
	КонецЕсли;
	
	ЗапрещенныеРасширения = ФайловыеФункцииСлужебный.СписокЗапрещенныхРасширений();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИмпортФайловЗавершен" Тогда
		Элементы.Список.Обновить();
		
		Если Параметр <> Неопределено Тогда
			Элементы.Список.ТекущаяСтрока = Параметр;
		КонецЕсли;
	КонецЕсли;
	
	Если ИмяСобытия = "ИмпортКаталоговЗавершен" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;

	Если ИмяСобытия = "Запись_Файл" И Параметр.Событие = "СозданФайл" Тогда
		Элементы.Список.Обновить();
		Если Параметр <> Неопределено И Параметр.Файл <> Неопределено Тогда
			Элементы.Список.ТекущаяСтрока = Параметр.Файл;
		КонецЕсли;
	КонецЕсли;
	
	Если ВРег(ИмяСобытия) = ВРег("Запись_НаборКонстант")
	   И (    ВРег(Источник) = ВРег("ИспользоватьЭлектронныеПодписи")
		  Или ВРег(Источник) = ВРег("ИспользоватьШифрование")) Тогда
			
		ПодключитьОбработчикОжидания("ПриИзмененияИспользованияПодписанияИлиШифрования", 0.3, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗапрещенныеРасширения.НайтиПоЗначению(Элементы.Список.ТекущиеДанные.ТекущаяВерсияРасширение) <> Неопределено Тогда
		Оповещение = Новый ОписаниеОповещения("ВыбратьФайлПослеПодтверждения", ЭтотОбъект);
		ПараметрыФормы = Новый Структура("Ключ", "ПередОткрытиемФайла");
		ПараметрыФормы.Вставить("ИмяФайла",
			ОбщегоНазначенияКлиентСервер.ПолучитьИмяСРасширением(Элементы.Список.ТекущиеДанные.Наименование, Элементы.Список.ТекущиеДанные.ТекущаяВерсияРасширение));
		ОткрытьФорму("ОбщаяФорма.ПредупреждениеБезопасности", ПараметрыФормы, , , , , Оповещение);
		Возврат;
	КонецЕсли;

	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(Элементы.Список.ТекущаяСтрока, УникальныйИдентификатор);
	РаботаСФайламиСлужебныйКлиент.ОткрытьФайлСОповещением(Неопределено, ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	УстановитьДоступностьФайловыхКоманд();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Просмотреть(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	Если ЗапрещенныеРасширения.НайтиПоЗначению(Элементы.Список.ТекущиеДанные.ТекущаяВерсияРасширение) <> Неопределено Тогда
		Оповещение = Новый ОписаниеОповещения("ОткрытьФайлПослеПодтверждения", ЭтотОбъект);
		ПараметрыФормы = Новый Структура("Ключ", "ПередОткрытиемФайла");
		ПараметрыФормы.Вставить("ИмяФайла",
			ОбщегоНазначенияКлиентСервер.ПолучитьИмяСРасширением(Элементы.Список.ТекущиеДанные.Наименование, Элементы.Список.ТекущиеДанные.ТекущаяВерсияРасширение));
		ОткрытьФорму("ОбщаяФорма.ПредупреждениеБезопасности", ПараметрыФормы, , , , , Оповещение);
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(Элементы.Список.ТекущаяСтрока, УникальныйИдентификатор);
	РаботаСФайламиКлиент.Открыть(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляСохранения(Элементы.Список.ТекущаяСтрока, УникальныйИдентификатор);
	РаботаСФайламиСлужебныйКлиент.СохранитьКак(Неопределено, ДанныеФайла, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура Освободить(Команда)
	
	Если Не ФайловыеКомандыДоступны() Тогда 
		Возврат;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("ОсвободитьЗавершение", ЭтотОбъект);
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	ПараметрыОсвобожденияФайла = РаботаСФайламиСлужебныйКлиент.ПараметрыОсвобожденияФайла(Обработчик, Элементы.Список.ТекущаяСтрока);
	ПараметрыОсвобожденияФайла.ХранитьВерсии = ТекущиеДанные.ХранитьВерсии;	
	ПараметрыОсвобожденияФайла.РедактируетТекущийПользователь = ТекущиеДанные.РедактируетТекущийПользователь;	
	ПараметрыОсвобожденияФайла.Редактирует = ТекущиеДанные.Редактирует;	
	РаботаСФайламиСлужебныйКлиент.ОсвободитьФайлСОповещением(ПараметрыОсвобожденияФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	Элементы.Список.Обновить();
	ПодключитьОбработчикОжидания("УстановитьДоступностьФайловыхКоманд", 0.1, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытьФайлПослеПодтверждения(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено И Результат = "Продолжить" Тогда
		
		ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(Элементы.Список.ТекущаяСтрока, УникальныйИдентификатор);
		РаботаСФайламиКлиент.Открыть(ДанныеФайла);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФайлПослеПодтверждения(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено И Результат = "Продолжить" Тогда
		ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(Элементы.Список.ТекущаяСтрока, УникальныйИдентификатор);
		РаботаСФайламиСлужебныйКлиент.ОткрытьФайлСОповещением(Неопределено, ДанныеФайла);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОсвободитьЗавершение(Результат, ПараметрыВыполнения) Экспорт
	УстановитьДоступностьФайловыхКоманд();
КонецПроцедуры

// Доступны файловые команды - есть хотя бы одна строка в списке и выделена не группировка.
&НаКлиенте
Функция ФайловыеКомандыДоступны()
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда 
		Возврат Ложь;
	КонецЕсли;
	
	Если ТипЗнч(Элементы.Список.ТекущаяСтрока) = Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		Возврат Ложь;
	КонецЕсли;	
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура УстановитьДоступностьФайловыхКоманд()
	
	Если Элементы.Список.ТекущиеДанные <> Неопределено Тогда
		
		Если ТипЗнч(Элементы.Список.ТекущаяСтрока) <> Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
			
			УстановитьДоступностьКоманд(Элементы.Список.ТекущиеДанные.РедактируетТекущийПользователь,
				Элементы.Список.ТекущиеДанные.Редактирует);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКоманд(РедактируетТекущийПользователь, Редактирует)
	
	Элементы.ФормаОсвободить.Доступность = ЗначениеЗаполнено(Редактирует);
	Элементы.СписокКонтекстноеМенюОсвободить.Доступность = ЗначениеЗаполнено(Редактирует);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененияИспользованияПодписанияИлиШифрования()
	
	ПриИзмененияИспользованияПодписанияИлиШифрованияНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененияИспользованияПодписанияИлиШифрованияНаСервере()
	
	ФайловыеФункцииСлужебный.КриптографияПриСозданииФормыНаСервере(ЭтотОбъект,, Истина);
	
КонецПроцедуры

#КонецОбласти
