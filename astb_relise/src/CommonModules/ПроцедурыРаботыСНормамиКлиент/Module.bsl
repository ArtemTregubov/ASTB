Функция ПолучитьМассивСловПредставляющихПериод(Текст) Экспорт
	
	МассивСлов = Новый Массив;
	ПоисковыйТекст = НРег(СокрЛП(Текст));
	ПозицияРазделителя = 1;
	Пока ПоисковыйТекст <> "" Цикл
		Слово = "";
		ПозицияРазделителя = 0;
		Если Найти(ПоисковыйТекст, " ") > 0 тогда
			 ПозицияРазделителя = ?(ПозицияРазделителя > 0, Мин(ПозицияРазделителя, Найти(ПоисковыйТекст, " ")), Найти(ПоисковыйТекст, " "));
		КонецЕсли;
		Если Найти(ПоисковыйТекст, ".") > 0 тогда
			 ПозицияРазделителя = ?(ПозицияРазделителя > 0, Мин(ПозицияРазделителя, Найти(ПоисковыйТекст, ".")), Найти(ПоисковыйТекст, "."));
		КонецЕсли;
		Если Найти(ПоисковыйТекст, "/") > 0 тогда
			 ПозицияРазделителя = ?(ПозицияРазделителя > 0, Мин(ПозицияРазделителя, Найти(ПоисковыйТекст, "/")), Найти(ПоисковыйТекст, "/"));
		КонецЕсли;
		Если Найти(ПоисковыйТекст, "\") > 0 тогда
			 ПозицияРазделителя = ?(ПозицияРазделителя > 0, Мин(ПозицияРазделителя, Найти(ПоисковыйТекст, "\")), Найти(ПоисковыйТекст, "\"));
		КонецЕсли;
		
		Если ПозицияРазделителя = 0 тогда
			Слово = СокрЛП(ПоисковыйТекст);
			ПоисковыйТекст = "";
		Иначе
			Слово = СокрЛП(Сред(ПоисковыйТекст, 1, ПозицияРазделителя-1));
		КонецЕсли;
		
		Если Слово <> " " И Слово <> "." И Слово <> "/" И Слово <> "\" И Слово <> "" тогда
			МассивСлов.Добавить(Слово);
		КонецЕсли;

		ПоисковыйТекст = СокрЛП(Прав(ПоисковыйТекст, СтрДлина(ПоисковыйТекст) - ПозицияРазделителя));
	КонецЦикла;
	
	Возврат МассивСлов;
	
КонецФункции

Функция СодержитСимволы(СтрокаНаПроверки, СтрокаСимволов)
	
	СодержатТолькоПодстроку = Истина;
	
	СимволыПроверки = Новый СписокЗначений;
	
	Для Сч = 1 По СтрДлина(СтрокаСимволов) Цикл
		СимволыПроверки.Добавить(КодСимвола(СтрокаСимволов, Сч));
	КонецЦикла;
	
	Для Сч = 1 По СтрДлина(СтрокаНаПроверки) Цикл
		Если СимволыПроверки.НайтиПоЗначению(КодСимвола(СтрокаНаПроверки, Сч)) = Неопределено Тогда
			СодержатТолькоПодстроку = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат СодержатТолькоПодстроку;
	
КонецФункции

Функция ПолучитьМесяц(СтрокаПредставленияМесяца)
	
	СписокМесяцев = Новый СписокЗначений;
	СписокМесяцев.Добавить(1, "янв");
	СписокМесяцев.Добавить(2, "фев");
	СписокМесяцев.Добавить(3, "мар");
	СписокМесяцев.Добавить(4, "апр");
	СписокМесяцев.Добавить(5, "май");
	СписокМесяцев.Добавить(6, "июн");
	СписокМесяцев.Добавить(7, "июл");
	СписокМесяцев.Добавить(8, "авг");
	СписокМесяцев.Добавить(9, "сень");
	СписокМесяцев.Добавить(10, "окт");
	СписокМесяцев.Добавить(11, "ноя");
	СписокМесяцев.Добавить(12, "дек");
	
	Месяц = Неопределено;
	
	Если СодержитСимволы(СтрокаПредставленияМесяца, "1234567890") Тогда
		Месяц = Число(СтрокаПредставленияМесяца);
	Иначе
		Для Каждого ЭлементСписка Из СписокМесяцев Цикл
			Если Найти(СтрокаПредставленияМесяца, ЭлементСписка.Представление) > 0 Тогда
				Месяц = ЭлементСписка.Значение;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Возврат Месяц;
	
КонецФункции 

// Возвращает фильтр, используемый для выбора файлов-изображений
// Возвращаемое значение:
// Строка - строка, содержащая фильтр для файлов-изображений
//
Функция ФильтрФайловИзображений() Экспорт
	
	Возврат НСтр("ru = 'Все картинки (*.bmp;*.gif;*.png;*.jpeg;*.dib;*.rle;*.tif;*.jpg;*.ico;*.wmf;*.emf)|*.bmp;*.gif;*.png;*.jpeg;*.dib;*.rle;*.tif;*.jpg;*.ico;*.wmf;*.emf"
		                            + "|Все файлы(*.*)|*.*"
		                            + "|Формат bmp(*.bmp*;*.dib;*.rle)|*.bmp;*.dib;*.rle"
		                            + "|Формат GIF(*.gif*)|*.gif"
		                            + "|Формат JPEG(*.jpeg;*.jpg)|*.jpeg;*.jpg"
		                            + "|Формат PNG(*.png*)|*.png"
		                            + "|Формат TIFF(*.tif)|*.tif"
		                            + "|Формат icon(*.ico)|*.ico"
		                            + "|Формат метафайл(*.wmf;*.emf)|*.wmf;*.emf'");
									
КонецФункции
								
Процедура ОбходДереваВверх(ТекущиеДанные) Экспорт

	Родитель = ТекущиеДанные.ПолучитьРодителя();
	Если Родитель <> Неопределено Тогда // Верхний уровень
		
		ДочерниеСтроки = Родитель.ПолучитьЭлементы();
		КоличествоВыбранных = 0;
		ОбщееКоличество = 0;
		Для каждого Элемент Из ДочерниеСтроки Цикл
			Если Элемент.Использовать = 2 Тогда
				КоличествоВыбранных = КоличествоВыбранных + 0.5;
			ИначеЕсли Элемент.Использовать = 1 Тогда
				КоличествоВыбранных = КоличествоВыбранных + 1;
			КонецЕсли;
			ОбщееКоличество = ОбщееКоличество + 1;
		КонецЦикла;
		
		Если ОбщееКоличество = КоличествоВыбранных Тогда
			Родитель.Использовать = 1;
		ИначеЕсли КоличествоВыбранных = 0 Тогда
			Родитель.Использовать = 0;
		Иначе
			Родитель.Использовать = 2;
		КонецЕсли;
		
		ОбходДереваВверх(Родитель);
		
	КонецЕсли;
	
КонецПроцедуры		

Процедура ОбходДереваВниз(ТекущиеДанные) Экспорт
	
	ДочерниеСтроки = ТекущиеДанные.ПолучитьЭлементы();
	Для каждого Элемент Из ДочерниеСтроки Цикл
		Элемент.Использовать = ТекущиеДанные.Использовать;
		ОбходДереваВниз(Элемент);
	КонецЦикла;
	
КонецПроцедуры

Функция ПреобразоватьДанныеСоСканераВМассив(Параметр) Экспорт
	
	Данные = Новый Массив;
	Данные.Добавить(ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
	
	Возврат Данные;
	
КонецФункции

Функция ПреобразоватьДанныеСоСканераВСтруктуру(Параметр) Экспорт
	
	Если Параметр[1] = Неопределено Тогда
		Данные = Новый Структура("Штрихкод, Количество", Параметр[0], 1); 	 // Достаем штрихкод из основных данных
	Иначе
		Данные = Новый Структура("Штрихкод, Количество", Параметр[1][1], 1); // Достаем штрихкод из дополнительных данных
	КонецЕсли;
	
	Возврат Данные;
	
КонецФункции

Процедура ИнициализироватьАлгоритмФормированияПотребности(ТекущийОбъект,НаименованиеАлгоритма) Экспорт
	
	МассивАлгоритмов = Новый Массив;
	МассивАлгоритмов.Добавить("ИспользоватьАлгоритм_0_0_0_3");
	МассивАлгоритмов.Добавить("ИспользоватьАлгоритм_0_0_0_4");
	МассивАлгоритмов.Добавить("ИспользоватьАлгоритм_0_1_0_3");
	МассивАлгоритмов.Добавить("ИспользоватьАлгоритм_0_0_1_2");
	МассивАлгоритмов.Добавить("ИспользоватьАлгоритм_1_0_1_1");
	
	Для Каждого ЭлементМассиваАлгоритмов Из МассивАлгоритмов Цикл
		
		Если ЭлементМассиваАлгоритмов = "Использовать" + НаименованиеАлгоритма Тогда
			ТекущийОбъект[ЭлементМассиваАлгоритмов] = Истина;
		Иначе
			ТекущийОбъект[ЭлементМассиваАлгоритмов] = Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура СкорректироватьКоличествоКомплектующих(ТекущаяНорма,ТекущийКомплект,ТекущееКоличество,ТекущийОбъект) Экспорт
	
	Для Каждого СтрокаТаблицы Из ТекущийОбъект.Товары Цикл
		
		Если СтрокаТаблицы.Комплект = ТекущийКомплект и СтрокаТаблицы.НормаВыдачи = ТекущаяНорма Тогда
			СтрокаТаблицы.Количество 	= ТекущееКоличество;
			СтрокаТаблицы.Сумма 		= СтрокаТаблицы.Количество * СтрокаТаблицы.Цена * СтрокаТаблицы.КоличествоВКомплекте;
		//закомментировал непонятную хрень:	
		//ИначеЕсли СтрокаТаблицы.Комплект = ТекущийКомплект Тогда
		//	СтрокаТаблицы.Количество 	= 0;
		//	СтрокаТаблицы.Сумма 		= 0;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПеренестиТекущиеДанныеВыдачиВСтруктуру(ТекущиеДанные) Экспорт
	
	Возврат Новый Структура("НомерСтроки, ДатаВыдачи, Количество, КоличествоВКомплекте, 
							|КоличествоПотребность, КоличествоСовпаденийНоменклатурыНормы, 
							|Комплект, НеВыдано, НеВыданоПоПричине, Номенклатура, 
							|НоменклатураНормы, НормаВыдачи, ПериодичностьВыдачи,     
							//Танцюра А.Н. -- №133496 Возможность проставлять процент износа в документе выдачи для комплектующих -- 13.10.2021 <<<
							|Сотрудник, Сумма, ХарактеристикаНоменклатуры, Цена, ПроцентИзноса",              
	                        //Танцюра А.Н. -- №133496 Возможность проставлять процент износа в документе выдачи для комплектующих -- 13.10.2021 >>>
							ТекущиеДанные.НомерСтроки, ТекущиеДанные.ДатаВыдачи, ТекущиеДанные.Количество, ТекущиеДанные.КоличествоВКомплекте, 
							ТекущиеДанные.КоличествоПотребность, ТекущиеДанные.КоличествоСовпаденийНоменклатурыНормы, 
							ТекущиеДанные.Комплект, ТекущиеДанные.НеВыдано, ТекущиеДанные.НеВыданоПоПричине, ТекущиеДанные.Номенклатура, 
							ТекущиеДанные.НоменклатураНормы, ТекущиеДанные.НормаВыдачи, ТекущиеДанные.ПериодичностьВыдачи,               
							//Танцюра А.Н. -- №133496 Возможность проставлять процент износа в документе выдачи для комплектующих -- 13.10.2021 <<<
							ТекущиеДанные.Сотрудник, ТекущиеДанные.Сумма, ТекущиеДанные.ХарактеристикаНоменклатуры, ТекущиеДанные.Цена, ТекущиеДанные.ПроцентИзноса);
							//Танцюра А.Н. -- №133496 Возможность проставлять процент износа в документе выдачи для комплектующих -- 13.10.2021 >>>
	
КонецФункции
						
Процедура ОткрытьКарточкуСотрудникаПоМагнитнойКарте(НомерКарты) Экспорт					
	
	Сотрудник = ПроцедурыРаботыСНормамиСервер.НайтиСотрудникаПоМагнитнойКарте(НомерКарты);
	
	Если НЕ Сотрудник = Неопределено Тогда
		
		СтруктураДляСотрудника = Новый Структура;
    	СтруктураДляСотрудника.Вставить("Ключ", Сотрудник);

   		ОткрытьФорму("Справочник.Сотрудники.ФормаОбъекта", СтруктураДляСотрудника);
		
	КонецЕсли;	
	
КонецПроцедуры							