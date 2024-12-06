import { readFileSync } from 'fs';

const ruleStr = rule => rule.join('|');

function parse(input) {
	const sections = input.split('\n\n');
	const rules =
		sections[0]
			.split('\n')
			.map(rule => rule.split('|').map(x => parseInt(x)));
	const updates =
		sections[1]
			.split('\n')
			.map(rule => rule.split(',').map(x => parseInt(x)));

	const rulesByAfter =
		Map.groupBy(rules, ([_, after]) => after);

	const ruleSet = new Set(rules.map(ruleStr));

	return { ruleSet, updates, rulesByAfter };
}

function isValid(update, rulesByAfter) {
	const disallowed = new Set();
	for (const page of update) {
		if (disallowed.has(page)) return false;
		for (const [before, _] of rulesByAfter.get(page) ?? []) {
			disallowed.add(before);
		}
	}
	return true;
}

const sumMiddles = updates => updates
	.map(pages => pages[(pages.length - 1) / 2])
	.reduce((x, y) => x + y, 0);

function part1(input) {
	const { updates, rulesByAfter } = parse(input);
	const validUpdates = updates.filter(update => isValid(update, rulesByAfter));
	return sumMiddles(validUpdates)
}

function part2(input) {
	const { ruleSet, updates, rulesByAfter } = parse(input);
	const invalidUpdates = updates.filter(update => !isValid(update, rulesByAfter));
	const correctedUpdates = invalidUpdates.map(
		update => update.toSorted((a, b) => ruleSet.has(ruleStr([b, a])) - ruleSet.has(ruleStr([a, b])))
	);
	return sumMiddles(correctedUpdates)
}

const example = `47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47`;

console.assert(part1(example) === 143);
console.log(part1(readFileSync('05.txt', {encoding: 'utf-8'})));
console.assert(part2(example) === 123);
console.log(part2(readFileSync('05.txt', {encoding: 'utf-8'})));

