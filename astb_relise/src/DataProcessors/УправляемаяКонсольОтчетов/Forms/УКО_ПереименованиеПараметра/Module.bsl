#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УКО_ФормыКлиентСервер_Заголовок(ЭтаФорма, СтрШаблон(НСтр("ru = 'Переименование параметра: %1'; en = 'Rename parameter: %1'"), Параметры.Имя));
	
	СтароеИмя = Параметры.Имя;
	НовоеИмя = Параметры.Имя;
	ВсеПараметры = Параметры.ВсеПараметры;
	ИспользуемыеИмена = СтрСоединить(ВсеПараметры.ВыгрузитьЗначения(), ", ");
	Элементы.ИспользуемыеИмена.Видимость = ЗначениеЗаполнено(ИспользуемыеИмена);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ТекстОшибки = "";
	
	Если НовоеИмя = СтароеИмя Тогда
		ТекстОшибки = НСтр("ru = 'Старое и новое имя совпадают'; en = 'Old and new name match'");
	КонецЕсли;
	
	Если Не УКО_СтрокиКлиентСервер_ЭтоКорректныйИдентификатор(НовоеИмя) Тогда
		ТекстОшибки = НСтр("ru = 'Неверное имя (идентификатор)'; en = 'Invalid name (identifier)'");
	КонецЕсли;
	
	ЕстьОшибка = ЗначениеЗаполнено(ТекстОшибки);
	Если ЕстьОшибка Тогда
		ПоказатьПредупреждение(, ТекстОшибки,,УКО_ОбщегоНазначенияКлиентСервер_ИмяРасширения());
	Иначе
		
		Если ВсеПараметры.НайтиПоЗначению(НовоеИмя) <> Неопределено Тогда
			
			ЕстьОшибка = Истина;
			
			ОписаниеОповещенияОЗавершении = Новый ОписаниеОповещения("ВопросИмяИспользуетсяЗавершение", ЭтотОбъект);
			ТекстВопроса = СтрШаблон(НСтр("ru = 'Имя параметра уже используется. 
			|При переименовании значение параметра: %1 будет потеряно. Продолжить?'; en = 'The parameter name is already in use. 
			|If you rename the parameter, the value: %1 will be lost. Continue?'"), СтароеИмя);
			
			ПоказатьВопрос(ОписаниеОповещенияОЗавершении, ТекстВопроса, РежимДиалогаВопрос.ДаНет,,,УКО_ОбщегоНазначенияКлиентСервер_ИмяРасширения());
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЕстьОшибка Тогда
		ЗакрытьФормуНовоеИмя();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗакрытьФормуНовоеИмя()
	
	Закрыть(НовоеИмя);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросИмяИспользуетсяЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда 
		ЗакрытьФормуНовоеИмя();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

&НаСервере
Функция ОбъектОбработки()
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции
&НаКлиентеНаСервереБезКонтекста

Функция УКО_СтрокиКлиентСервер_НаборСимволовЦифры()
	
	Возврат "0123456789";
	
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Проверяет является ли строка корректным идентификатором, строка вида СуммаКонтрагента, _Идентификатор
//
// Параметры:
//   Строка - Строка - Проверяемая строка
//
// Возвращаемое значение:
//   Булево - Истина, идентификатор корректный
//
Функция УКО_СтрокиКлиентСервер_ЭтоКорректныйИдентификатор(Строка) Экспорт
	
	ПервыйСимволСимволы = УКО_СтрокиКлиентСервер_НаборСимволовРусскиеЛатинскиеБуквы() + "_";
	ПоследующиеСимволы = УКО_СтрокиКлиентСервер_НаборСимволовРусскиеЛатинскиеБуквы() + УКО_СтрокиКлиентСервер_НаборСимволовЦифры() + "_";
	 
	Если ПустаяСтрока(Строка) ИЛИ Не СтрНайти(ПервыйСимволСимволы, Лев(Строка, 1)) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Для Сч = 2 По СтрДлина(Строка) Цикл 
		
		Символ = Сред(Строка, Сч, 1);
		
		Если Не СтрНайти(ПоследующиеСимволы, Символ) Тогда
			Возврат Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Возвращает имя расширения
// Возвращаемое значение:
//   Строка	- Имя расширения
Функция УКО_ОбщегоНазначенияКлиентСервер_ИмяРасширения() Экспорт 
	
	Возврат НСтр("ru = 'Управляемая консоль отчетов'; en = 'Managed reporting console'");
	
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Обновляет заголовок формы
//
// Параметры:
//  Форма - Форма - Форма
//  Заголовок - Строка - Заголовок формы
//  Дополнение - Булево - Дополнять заголовок названием расширения
//
Процедура УКО_ФормыКлиентСервер_Заголовок(Форма, Заголовок, Дополнение = Ложь) Экспорт
	
	НовыйЗаголовок = Заголовок;
	
	Если Дополнение Тогда
		НовыйЗаголовок = НовыйЗаголовок + " : " + УКО_ОбщегоНазначенияКлиентСервер_ИмяРасширения();
	КонецЕсли;
	
	Форма.Заголовок = НовыйЗаголовок;
	
КонецПроцедуры
&НаКлиентеНаСервереБезКонтекста

Функция УКО_СтрокиКлиентСервер_НаборСимволовЛатинскиеБуквы()
	
	НаборСимволов = "QWERTYUIOPASDFGHJKLZXCVBNM";
	Возврат НаборСимволов + НРег(НаборСимволов);
	
КонецФункции
&НаКлиентеНаСервереБезКонтекста
// Возвращает набор символов букв русского и английского языков
// Возвращаемое значение:
//   Строка - Набор символов букв
Функция УКО_СтрокиКлиентСервер_НаборСимволовРусскиеЛатинскиеБуквы()
	
	НаборСимволовРусскиеБуквы = "ЙЦУКЕ" + Символ(1025) + "НГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ"; //1025 - Код символа буквы ежик, елка
	НаборСимволовРусскиеБуквы = НаборСимволовРусскиеБуквы + НРег(НаборСимволовРусскиеБуквы);
	
	Возврат НаборСимволовРусскиеБуквы + УКО_СтрокиКлиентСервер_НаборСимволовЛатинскиеБуквы();
	
КонецФункции
