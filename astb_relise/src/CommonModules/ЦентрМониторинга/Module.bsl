////////////////////////////////////////////////////////////////////////////////
// Подсистема "Центр Мониторинга"
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Записывает операцию бизнес статистики.
//
// Параметры:
//  ИмяОперации	- Строка(1000)	- имя операции статистики, в случае отсутствия - создается новое;
//  Значение	- Число(15,3)	- количественное значение операции статистики;
//  Комментарий	- Строка(1000)	- произвольный комментарий.
//	Разделитель	- Строка		- разделитель значений в <ИмяОперации>, если разделитель не точка.
//
Процедура ЗаписатьОперациюБизнесСтатистики(ИмяОперации, Значение, Комментарий = Неопределено, Разделитель = ".") Экспорт
	Если ЦентрМониторингаВызовСервераПовтИсп.ЗаписыватьОперацииБизнесСтатистики() Тогда
		РегистрыСведений.БуферОперацийСтатистики.ЗаписатьОперациюБизнесСтатистики(ИмяОперации, Значение, Комментарий, Разделитель);
	КонецЕсли;
КонецПроцедуры

// Записывает статистику по объектам конфигурации.
//
// Параметры:
//  СоответствиеИменМетаданных - Структура;
//   * Ключ		- Строка - 	Имя объекта метаданных;
//   * Значение	- Строка - 	Текст запроса выборки данных, обязательно должно
//							присутствовать поле <Количество>.
// Ограничения
//  можно вызывать только из ЦентрМониторингаПереопределяемый.ПриСбореПоказателейСтатистикиКонфигурации.
//
Процедура ЗаписатьСтатистикуКонфигурации(СоответствиеИменМетаданных) Экспорт
	Параметры = Новый Соответствие;
	Для Каждого ТекМетаданные Из СоответствиеИменМетаданных Цикл
		Параметры.Вставить(ТекМетаданные.Ключ, Новый Структура("Запрос, ОперацииСтатистики, ВидСтатистики", ТекМетаданные.Значение,,0));
	КонецЦикла;
	
	Если ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		ОбластьДанныхСтрока = Строка(ОбщегоНазначения.ЗначениеРазделителяСеанса());
	Иначе
		ОбластьДанныхСтрока = "0";
	КонецЕсли;
	ОбластьДанныхСсылка = РегистрыСведений.ОбластиСтатистики.ПолучитьСсылку(ОбластьДанныхСтрока);
	
	РегистрыСведений.СтатистикаКонфигурации.Записать(Параметры, ОбластьДанныхСсылка);
КонецПроцедуры

// Записывает статистику по объекту конфигурации.
//
// Параметры:
//  ИмяОбъекта -	Строка(1000)	- имя операции статистики, в случае отсутствия - создается новое;
//  Значение - 		Число(15,3)		- количественное значение операции статистики; 
// Ограничения
//  можно вызывать только из ЦентрМониторингаПереопределяемый.ПриСбореПоказателейСтатистикиКонфигурации,
//  значение равное нулю не записывается.
//
Процедура ЗаписатьСтатистикуОбъектаКонфигурации(ИмяОбъекта, Значение) Экспорт
    
    Если Значение <> 0 Тогда
        ОперацияСтатистики = РегистрыСведений.ОперацииСтатистики.ПолучитьСсылку(ИмяОбъекта);
        
        Если ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
            ОбластьДанныхСтрока = Строка(ОбщегоНазначения.ЗначениеРазделителяСеанса());
        Иначе
            ОбластьДанныхСтрока = "0";
        КонецЕсли;
        ОбластьДанныхСсылка = РегистрыСведений.ОбластиСтатистики.ПолучитьСсылку(ОбластьДанныхСтрока);
        
        НаборЗаписей = РегистрыСведений.СтатистикаКонфигурации.СоздатьНаборЗаписей();
        НаборЗаписей.Отбор.ОперацияСтатистики.Установить(ОперацияСтатистики);
        
        НовЗапись = НаборЗаписей.Добавить();
        НовЗапись.ИдентификаторОбластиСтатистики = ОбластьДанныхСсылка;
        НовЗапись.ОперацияСтатистики = ОперацияСтатистики;
        НовЗапись.Значение = Значение;	
        НаборЗаписей.Записать(Истина);
    КонецЕсли;
    
КонецПроцедуры

#КонецОбласти